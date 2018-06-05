require 'test_helper'

class PaymentIconTest < ActiveSupport::TestCase

  ICONS_DIRECTORY = PaymentIcons::Engine.root.join("app/assets/images/payment_icons")

  test "Every payment icon record is valid" do
    PaymentIcon.all.each do |icon|
      assert_predicate icon.name, :present?
      assert_predicate icon.label, :present?
      assert_includes PaymentIcon::GROUPS.keys, icon.group.to_sym
    end
  end

  test '#path returns path within app/assets/images' do
    visa = PaymentIcon.where(name: 'visa').first
    assert_equal 'payment_icons/visa.svg', visa.path
  end

  test 'Every payment icon record has a corresponding SVG file' do
    PaymentIcon.all.each do |icon|
      assert File.exist?(ICONS_DIRECTORY.join("#{icon.name}.svg"))
    end
  end

  test 'Every payment icon record has a unique "name"' do
    names = PaymentIcon.all.map(&:name)
    duplicates = names.detect {|e| names.rindex(e) != names.index(e) }
    assert !duplicates.present?, "The payment_icons.yml file contains duplicate records: #{duplicates}"
  end

  test 'Every payment icon SVG has a valid XML tree' do
    PaymentIcon.all.each do |icon|
      file = File.read(ICONS_DIRECTORY.join("#{icon.name}.svg")).freeze
      document = Nokogiri::XML.parse(file)
      assert document.errors.blank?,
        message: "The '#{icon.name}' SVG file is invalid: #{document.errors}. Please fix the errors, then optimize the file using SVGO."
    end
  end

  test "Every payment SVG meets accessibility requirements" do
    PaymentIcon.all.each do |icon|
      file = File.read(ICONS_DIRECTORY.join("#{icon.name}.svg")).freeze
      document = Nokogiri::XML.parse(file)

      assert_equal 1, document.root.search('title').count,
        message: "The '#{icon.name}' SVG file should have a single <title> node"

      assert document.root.search('title').present?,
        message: "The '#{icon.name}' SVG file should have a <title> node as a child of the root <svg> node"
      
      assert_equal icon.label, document.root.at('title').content,
        message: "The '#{icon.name}' SVG file does not have the appropriate <title> value"

      assert document.root.key?('role'),
        message: "The '#{icon.name}' SVG file should have a 'role' attribute on the root <svg> node"
        
      assert_equal "img", document.root['role'],
        message: "The '#{icon.name}' SVG file should have a role='img' attribute on the root <svg> node"
    end
  end
end

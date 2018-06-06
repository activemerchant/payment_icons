require 'test_helper'

class PaymentIconTest < ActiveSupport::TestCase

  ICONS_DIRECTORY = PaymentIcons::Engine.root.join("app/assets/images/payment_icons")
  SVG_PAYMENT_TYPES = Dir[ICONS_DIRECTORY.join('*.svg')].each_with_object({}) do |path, hash|
    hash[File.basename(path, '.svg')] = File.read(path).freeze
  end.freeze

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
      assert SVG_PAYMENT_TYPES.key?(icon.name)
    end
  end

  test 'Every payment icon record has a unique "name"' do
    names = PaymentIcon.all.map(&:name)
    duplicates = names.detect {|e| names.rindex(e) != names.index(e) }
    assert !duplicates.present?, "The payment_icons.yml file contains duplicate records: #{duplicates}"
  end

  test 'Every payment icon SVG has a valid XML tree' do
    PaymentIcon.all.each do |icon|
      document = Nokogiri::XML.parse(SVG_PAYMENT_TYPES[icon.name])
      assert document.errors.blank?,
        message: "The '#{icon.name}' SVG file is invalid: #{document.errors}. Please fix the errors, then optimize the file using SVGO."
    end
  end

  test 'Every payment icon SVG is 38x24 pixels' do
    PaymentIcon.all.each do |icon|
      document = Nokogiri::XML.parse(SVG_PAYMENT_TYPES[icon.name])
      assert_equal 38, document.root["width"].to_i,
        message: "The '#{icon.name}' SVG file must be 38 pixels wide"
      assert_equal 24, document.root["height"].to_i,
        message: "The '#{icon.name}' SVG file must be 24 pixels high"
    end
  end

  test "Every payment SVG meets accessibility requirements" do
    ICON_ID_PREFIX = "pi-"

    PaymentIcon.all.each do |icon|
      document = Nokogiri::XML.parse(SVG_PAYMENT_TYPES[icon.name])
      icon_id = ICON_ID_PREFIX + icon.name

      assert_equal 1, document.root.search('title').count,
        message: "The '#{icon.name}' SVG file should have a single <title> tag"

      assert document.root.search('title').present?,
        message: "The '#{icon.name}' SVG file should have a <title> tag as a child of the root <svg> tag"

      assert_equal "title", document.root.first_element_child.name,
        message: "The '#{icon.name}' SVG file should have a <title> tag as first child of the root <svg> tag"
      
      assert_equal icon.label, document.root.at('title').content,
        message: "The '#{icon.name}' SVG file does not have the appropriate <title> value"

      assert_equal icon_id, document.root.at('title')['id'],
        message: "The '#{icon.name}' SVG file does not have the appropriate 'id' value on the <title> tag"

      assert document.root.key?('role'),
        message: "The '#{icon.name}' SVG file should have a 'role' attribute on the root <svg> tag"
        
      assert_equal "img", document.root['role'],
        message: "The '#{icon.name}' SVG file should have a role='img' attribute on the root <svg> tag"

      assert document.root.key?('aria-labelledby'),
        message: "The '#{icon.name}' SVG file should have a 'aria-labelledby' attribute on the root <svg> node"

      assert_equal icon_id, document.root['aria-labelledby'],
        message: "The '#{icon.name}' SVG file should have a aria-labelledby='#{ICON_ID_PREFIX}#{icon.name}' attribute on the root <svg> node"
    end
  end
end

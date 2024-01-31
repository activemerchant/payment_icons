# frozen_string_literal: true

require "test_helper"

module PaymentIcons
  class IconSpecTest < ActiveSupport::TestCase
    ICONS_DIRECTORY = Engine::IMAGES_DIRECTORY.join("payment_icons")

    SVG_FILES = Dir.glob("#{ICONS_DIRECTORY}/*/*").each_with_object({}) do |file_path, hash|
      folder_name = File.basename(File.dirname(file_path))
      filename = File.basename(file_path)
      key = "#{folder_name}/#{filename}"
      content = File.read(file_path)
      hash[key] = content
    end

    test "Every icon SVG has a valid XML tree" do
      SVG_FILES.each do |payment_file, svg|
        document = Nokogiri::XML.parse(svg)
        assert document.errors.blank?,
          message: "The '#{payment_file}' SVG file is invalid: #{document.errors}. Please fix the errors, then optimize the file using SVGO."
      end
    end

    test "Every icon SVG is 38x24 pixels" do
      SVG_FILES.each do |payment_file, svg|
        document = Nokogiri::XML.parse(svg)
        assert_equal 38,
          document.root["width"].to_i,
          message: "The '#{payment_file}' SVG file must be 38 pixels wide"
        assert_equal 24,
          document.root["height"].to_i,
          message: "The '#{payment_file}' SVG file must be 24 pixels high"
      end
    end

    test "Every icon SVG has a viewBox attribute" do
      SVG_FILES.each do |payment_file, svg|
        document = Nokogiri::XML.parse(svg)
        assert document.root.key?("viewBox"),
          message: "The '#{payment_file}' SVG file should have a 'viewBox' attribute on the root <svg> tag"
      end
    end

    test "Every payment SVG meets accessibility requirements" do
      ICON_ID_PREFIX = "pi-"

      SVG_FILES.each do |payment_file, svg|
        document = Nokogiri::XML.parse(svg)
        payment_method_name = payment_file.split("/").first
        icon_id = ICON_ID_PREFIX + payment_method_name

        assert_equal 1,
          document.root.search("title").count,
          message: "The '#{payment_file}' SVG file should have a single <title> tag"

        assert document.root.search("title").present?,
          message: "The '#{payment_file}' SVG file should have a <title> tag as a child of the root <svg> tag"

        assert_equal "title",
          document.root.first_element_child.name,
          message: "The '#{payment_file}' SVG file should have a <title> tag as first child of the root <svg> tag"

        expected_title = PaymentIcon.where(name: payment_method_name).present? ? PaymentIcon.where(name: payment_method_name).first.label : payment_method_name.titleize
        assert_equal expected_title,
          document.root.at("title").content,
          message: "The '#{payment_file}' SVG file does not have the appropriate <title> value"

        assert_equal icon_id,
          document.root.at("title")["id"],
          message: "The '#{payment_method_name}' SVG file does not have the appropriate 'id' value on the <title> tag"

        document.xpath("//*[@id]").each do |element|
          actual_element_id = element.attr("id")
          expected_element_id = "#{icon_id}-#{actual_element_id}"
          expected_element_id_regex = /#{ICON_ID_PREFIX}(.*)/

          assert_match expected_element_id_regex,
            actual_element_id,
            message: "The '#{actual_element_id}' ID should be #{expected_element_id} (missing '#{ICON_ID_PREFIX}' prefix)"
        end

        assert document.root.key?("role"),
          message: "The '#{payment_file}' SVG file should have a 'role' attribute on the root <svg> tag"

        assert_equal "img",
          document.root["role"],
          message: "The '#{payment_file}' SVG file should have a role='img' attribute on the root <svg> tag"

        assert document.root.key?("aria-labelledby"),
          message: "The '#{payment_file}' SVG file should have a 'aria-labelledby' attribute on the root <svg> node"

        assert_equal icon_id,
          document.root["aria-labelledby"],
          message: "The '#{payment_file}' SVG file should have a aria-labelledby='#{ICON_ID_PREFIX}#{payment_file}' attribute on the root <svg> node"
      end
    end

    test "Icon SVGs with <img> or <image> tags base64-encode PNG image data" do
      SVG_FILES.each do |_payment_file, svg|
        document = Nokogiri::XML.parse(svg)

        image_nodes = []
        image_nodes << document.search("img")
        image_nodes << document.search("image")
        image_nodes.flatten!.uniq!

        image_nodes.each do |image_node|
          xlink_href_content = image_node["xlink:href"]
          error_message = "Expected image tag to contain base64 encoded PNG, found '#{xlink_href_content.truncate(50)}' instead"
          assert xlink_href_content.start_with?("data:image/png;base64"), error_message
        end
      end
    end

    test "Icon SVGs are a single line" do
      SVG_FILES.each do |payment_file, svg|
        error_message = "The '#{payment_file}' SVG file should contain a single line of markup, optionally terminated by an empty line"
        assert svg.lines.count == 1 || (svg.lines.count == 2 && svg.lines[1] == ""), error_message
      end
    end
  end
end

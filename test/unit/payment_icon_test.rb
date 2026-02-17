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
    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      document = Nokogiri::XML.parse(svg)
      assert document.errors.blank?,
        message: "The '#{payment_type}' SVG file is invalid: #{document.errors}. Please fix the errors, then optimize the file using SVGO."
    end
  end

  test 'Every payment icon SVG is 38x24 pixels' do
    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      document = Nokogiri::XML.parse(svg)
      assert_equal 38, document.root["width"].to_i,
        message: "The '#{payment_type}' SVG file must be 38 pixels wide"
      assert_equal 24, document.root["height"].to_i,
        message: "The '#{payment_type}' SVG file must be 24 pixels high"
    end
  end

  test 'Every payment icon SVG has a viewBox attribute' do
    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      document = Nokogiri::XML.parse(svg)
      assert document.root.key?('viewBox'),
        message: "The '#{payment_type}' SVG file should have a 'viewBox' attribute on the root <svg> tag"
    end
  end

  test "Every payment SVG meets accessibility requirements" do
    ICON_ID_PREFIX = "pi-"

    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      document = Nokogiri::XML.parse(svg)
      icon_id = ICON_ID_PREFIX + payment_type

      assert_equal 1, document.root.search('title').count,
        message: "The '#{payment_type}' SVG file should have a single <title> tag"

      assert document.root.search('title').present?,
        message: "The '#{payment_type}' SVG file should have a <title> tag as a child of the root <svg> tag"

      assert_equal "title", document.root.first_element_child.name,
        message: "The '#{payment_type}' SVG file should have a <title> tag as first child of the root <svg> tag"

      expected_title = PaymentIcon.where(name: payment_type).present? ? PaymentIcon.where(name: payment_type).first.label : payment_type.titleize
      assert_equal expected_title, document.root.at('title').content,
        message: "The '#{payment_type}' SVG file does not have the appropriate <title> value"

      assert_equal icon_id, document.root.at('title')['id'],
        message: "The '#{payment_type}' SVG file does not have the appropriate 'id' value on the <title> tag"

      document.xpath("//*[@id]").each do |element|
        actual_element_id = element.attr('id')
        expected_element_id = "#{icon_id}-#{actual_element_id}"
        expected_element_id_regex = /#{ICON_ID_PREFIX}(.*)/

        assert_match expected_element_id_regex, actual_element_id,
          message: "The '#{actual_element_id}' ID should be #{expected_element_id} (missing '#{ICON_ID_PREFIX}' prefix)"
      end

      assert document.root.key?('role'),
        message: "The '#{payment_type}' SVG file should have a 'role' attribute on the root <svg> tag"

      assert_equal "img", document.root['role'],
        message: "The '#{payment_type}' SVG file should have a role='img' attribute on the root <svg> tag"

      assert document.root.key?('aria-labelledby'),
        message: "The '#{payment_type}' SVG file should have a 'aria-labelledby' attribute on the root <svg> node"

      assert_equal icon_id, document.root['aria-labelledby'],
        message: "The '#{payment_type}' SVG file should have a aria-labelledby='#{ICON_ID_PREFIX}#{payment_type}' attribute on the root <svg> node"
    end
  end

  test 'Payment icon SVGs with <img> or <image> tags base64-encode PNG image data' do
    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      document = Nokogiri::XML.parse(svg)

      image_nodes = []
      image_nodes << document.search("img")
      image_nodes << document.search("image")
      image_nodes.flatten!.uniq!

      image_nodes.each do |image_node|
        xlink_href_content = image_node['xlink:href']
        error_message = "Expected image tag to contain base64 encoded PNG, found '#{xlink_href_content.truncate(50)}' instead"
        assert xlink_href_content.start_with?('data:image/png;base64'), error_message
      end
    end
  end

  test 'Payment icon SVGs are a single line' do
    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      error_message = "The '#{payment_type}' SVG file should contain a single line of markup, optionally terminated by an empty line"
      assert svg.lines.count == 1 || (svg.lines.count == 2 && svg.lines[1] == ''), error_message
    end
  end

  test 'Every payment icon SVG has XML namespace' do
    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      document = Nokogiri::XML.parse(svg)

      assert document.root.namespace.present?,
        message: "The '#{payment_type}' SVG must have an xmlns namespace"

      assert_equal 'http://www.w3.org/2000/svg', document.root.namespace.href,
        message: "The '#{payment_type}' SVG must have xmlns='http://www.w3.org/2000/svg'"
    end
  end

  test 'Payment icon SVGs do not contain style tags' do
    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      document = Nokogiri::XML.parse(svg)

      style_tags = document.search('style')
      assert_equal 0, style_tags.count,
        message: "The '#{payment_type}' SVG must not contain <style> tags. Use inline styles instead."
    end
  end

  test 'Payment icon SVGs do not contain class attributes' do
    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      document = Nokogiri::XML.parse(svg)

      elements_with_class = document.xpath('//*[@class]')
      assert_equal 0, elements_with_class.count,
        message: "The '#{payment_type}' SVG must not contain class attributes"
    end
  end

  test 'Payment icon SVGs use vector graphics only' do
    FORBIDDEN_RASTER_ELEMENTS = %w[img foreignObject]

    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      document = Nokogiri::XML.parse(svg)

      FORBIDDEN_RASTER_ELEMENTS.each do |element|
        found = document.search(element)
        assert_equal 0, found.count,
          message: "The '#{payment_type}' SVG must not contain <#{element}> elements (raster images not allowed)"
      end
    end
  end

  test 'Payment icon SVGs do not contain embedded fonts' do
    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      document = Nokogiri::XML.parse(svg)

      # Check for font elements
      font_elements = document.search('font-face, font')
      assert_equal 0, font_elements.count,
        message: "The '#{payment_type}' SVG must not contain embedded fonts"
    end
  end

  test 'Payment icon SVGs have standard border with correct styling' do
    # Get list of changed icons from environment (for selective enforcement)
    changed_icons = ENV['CHANGED_ICONS']&.split(',')&.map(&:strip)

    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      document = Nokogiri::XML.parse(svg)

      # Determine if this is a new/modified icon
      is_changed = changed_icons && changed_icons.include?(payment_type)

      # Border can be either a <path> or <rect> element
      # Check for path-based border (standard template)
      border_path = document.at_xpath("//svg:svg/svg:path[@opacity]", 'svg' => 'http://www.w3.org/2000/svg')

      # Check for rect-based border (alternative pattern)
      border_rect = document.at_xpath("//svg:svg/svg:rect[@stroke-opacity or @opacity]", 'svg' => 'http://www.w3.org/2000/svg')

      # Check if border is missing
      if !border_path.present? && !border_rect.present?
        if is_changed
          # NEW/MODIFIED ICON: FAIL the test (critical violation)
          assert false,
            "The '#{payment_type}' SVG must have a standard border element.\n" \
            "Add either:\n" \
            "  - <path opacity=\".07\" d=\"...\"/> (recommended), or\n" \
            "  - <rect stroke=\"#000\" stroke-opacity=\".07\" .../>\n" \
            "See CONTRIBUTING.md for details."
        else
          # EXISTING ICON: Just warn (grandfathered)
          puts "\nWARNING: '#{payment_type}' is missing standard border (pre-existing violation)"
        end
        next
      end

      if border_path
        # Validate path-based border
        opacity = border_path['opacity']
        opacity_float = opacity.to_f

        # Check opacity (WARNING for all icons, including new ones)
        if (opacity_float - 0.07).abs > 0.001
          if is_changed
            puts "\nWARNING: '#{payment_type}' border opacity should be '.07' (got '#{opacity}') [new/modified icon]"
          else
            puts "\nWARNING: '#{payment_type}' border opacity should be '.07' (got '#{opacity}')"
          end
        end

        # Check fill color - accept missing (defaults to black) OR explicit black
        fill = border_path['fill']
        is_black = fill.nil? || fill.empty? || ['#000', '#000000', 'black'].include?(fill)
        if !is_black
          if is_changed
            puts "\nWARNING: '#{payment_type}' border should be black or default (got '#{fill}') [new/modified icon]"
          else
            puts "\nWARNING: '#{payment_type}' border should be black or default (got '#{fill}')"
          end
        end

      elsif border_rect
        # Validate rect-based border
        stroke_opacity = border_rect['stroke-opacity'] || border_rect['opacity']
        opacity_float = stroke_opacity.to_f

        # Check opacity (WARNING for all icons, including new ones)
        if (opacity_float - 0.07).abs > 0.001
          if is_changed
            puts "\nWARNING: '#{payment_type}' border stroke-opacity should be '.07' (got '#{stroke_opacity}') [new/modified icon]"
          else
            puts "\nWARNING: '#{payment_type}' border stroke-opacity should be '.07' (got '#{stroke_opacity}')"
          end
        end

        # Check stroke color
        stroke = border_rect['stroke']
        is_black = stroke.nil? || stroke.empty? || ['#000', '#000000', 'black'].include?(stroke)
        if !is_black
          if is_changed
            puts "\nWARNING: '#{payment_type}' border stroke should be black (got '#{stroke}') [new/modified icon]"
          else
            puts "\nWARNING: '#{payment_type}' border stroke should be black (got '#{stroke}')"
          end
        end
      end
    end
  end

  test 'Payment icon SVGs are optimized and under size limit' do
    SIZE_SOFT_LIMIT_KB = 10.0  # Soft limit: recommended size
    SIZE_HARD_LIMIT_KB = 15.0  # Hard limit: maximum acceptable size

    # Get list of changed icons from environment (for selective enforcement)
    changed_icons = ENV['CHANGED_ICONS']&.split(',')&.map(&:strip)

    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      size_kb = svg.bytesize / 1024.0

      # Determine if this is a new/modified icon
      is_changed = changed_icons && changed_icons.include?(payment_type)

      # Check hard limit (15KB)
      if size_kb >= SIZE_HARD_LIMIT_KB
        if is_changed
          # NEW/MODIFIED ICON: FAIL the test (critical violation)
          assert false,
            "The '#{payment_type}' SVG file is too large (#{size_kb.round(2)}KB).\n" \
            "Hard limit: #{SIZE_HARD_LIMIT_KB}KB (must be under this size).\n" \
            "Recommended: #{SIZE_SOFT_LIMIT_KB}KB for optimal performance.\n\n" \
            "To reduce file size:\n" \
            "  1. Run SVGO optimization: svgo #{payment_type}.svg\n" \
            "  2. Simplify complex paths\n" \
            "  3. Remove unnecessary elements/attributes\n" \
            "  4. Consider design simplification if still too large"
        else
          # EXISTING ICON: Just warn (grandfathered)
          puts "\nWARNING: '#{payment_type}' is #{size_kb.round(2)}KB (hard limit: #{SIZE_HARD_LIMIT_KB}KB) [pre-existing violation]"
        end

      # Check soft limit (10KB)
      elsif size_kb >= SIZE_SOFT_LIMIT_KB
        if is_changed
          puts "\nWARNING: '#{payment_type}' is #{size_kb.round(2)}KB (recommended: under #{SIZE_SOFT_LIMIT_KB}KB) [new/modified icon]"
        else
          puts "\nWARNING: '#{payment_type}' is #{size_kb.round(2)}KB (recommended: under #{SIZE_SOFT_LIMIT_KB}KB)"
        end
      end
    end
  end

  test 'Payment icon SVGs do not link to external stylesheets' do
    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      refute svg.include?('<?xml-stylesheet'),
        message: "The '#{payment_type}' SVG must not link to external stylesheets. Use inline styles instead."
    end
  end

  test 'Every payment icon SVG has viewBox of 0 0 38 24' do
    # Get list of changed icons from environment (for selective enforcement)
    changed_icons = ENV['CHANGED_ICONS']&.split(',')&.map(&:strip)

    SVG_PAYMENT_TYPES.each do |payment_type, svg|
      document = Nokogiri::XML.parse(svg)

      # Determine if this is a new/modified icon
      is_changed = changed_icons && changed_icons.include?(payment_type)

      actual_viewbox = document.root['viewBox']
      if actual_viewbox != '0 0 38 24'
        if is_changed
          # NEW/MODIFIED ICON: FAIL the test (critical violation)
          assert_equal '0 0 38 24', actual_viewbox,
            message: "The '#{payment_type}' SVG must have viewBox='0 0 38 24' (got '#{actual_viewbox}')"
        else
          # EXISTING ICON: Just warn (grandfathered)
          puts "\nWARNING: '#{payment_type}' has incorrect viewBox '#{actual_viewbox}' (should be '0 0 38 24') [pre-existing violation]"
        end
      end
    end
  end

  test 'Every payment icon name uses valid characters' do
    # Pattern: Start with lowercase, can contain lowercase/numbers,
    # uppercase letters ONLY allowed directly after a number
    # NO underscores, hyphens, or special characters allowed
    valid_name_pattern = /\A[a-z](?:(?![0-9][a-z])[a-z0-9]|(?<=[0-9])[A-Z])*\z/

    # Get list of NEW icons from environment (for selective enforcement)
    # Note: We only enforce strict naming on NEW icons, not modified ones
    # because renaming is a breaking change for existing integrations
    new_icons = ENV['NEW_ICONS']&.split(',')&.map(&:strip)

    PaymentIcon.all.each do |icon|
      # Determine if this is a NEW icon (not just modified)
      is_new = new_icons && new_icons.include?(icon.name)

      unless valid_name_pattern.match?(icon.name)
        if is_new
          # NEW ICON: FAIL the test (must follow naming rules)
          assert false,
            "The icon name '#{icon.name}' must start with a lowercase letter and contain only lowercase letters and numbers. " \
            "Any letter directly following a number must be capitalized (e.g., 'visa1Card' is valid, 'visa1card' or 'visa_pay' are invalid)."
        else
          # EXISTING/MODIFIED ICON: Just warn (grandfathered to avoid breaking changes)
          puts "\nWARNING: '#{icon.name}' uses invalid characters (should not contain underscores/hyphens) [pre-existing violation]"
        end
      end
    end
  end

  # NOTE: Base64 image policy decision needed
  # Your AI guidelines say "avoid base64 images" but existing test (line 107-122)
  # allows base64 PNG images. Choose ONE of the following tests:

  # OPTION A: Strict - NO base64 images allowed (uncomment to use)
  # test 'Payment icon SVGs do not contain base64 images' do
  #   SVG_PAYMENT_TYPES.each do |payment_type, svg|
  #     refute svg.include?('data:image'),
  #       message: "The '#{payment_type}' SVG must not contain base64-encoded images. Use vector paths instead."
  #   end
  # end

  # OPTION B: Pragmatic - Allow base64 PNG only (current behavior)
  # The existing test at lines 107-122 already handles this case
  # No additional test needed - it validates that IF images exist, they must be base64 PNG
end

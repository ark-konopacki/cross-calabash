# Workaround for multiple launch activities
# Can be removed if not needed
def main_activity(app)
  unless File.exist?(app)
    raise "Application '#{app}' does not exist"
  end

  begin
    log("Trying to find launchable activity")
    launchable_activity_line = aapt_dump(app, "launchable-activity").first
    raise "'launchable-activity' not found in aapt output" unless launchable_activity_line
    m = launchable_activity_line.match(/name='([^']+)'/)
    raise "Unexpected output from aapt: #{launchable_activity_line}" unless m
    log("Found launchable activity '#{m[1]}'")
    m[1]
  rescue => e
    log("Could not find launchable activity, trying to parse raw AndroidManifest. #{e.message}")

    manifest_data = `"#{Env.tools_dir}/aapt" dump xmltree "#{app}" AndroidManifest.xml`
    regex = /^\s*A:[\s*]android:name\(\w+\)\=\"android.intent.category.LAUNCHER\"/
    lines = manifest_data.lines.collect(&:strip)
    indicator_line = nil

    duplicate_line = ''

    lines.each_with_index do |line, index|

      match = line.match(regex)

      unless match.nil?
        if duplicate_line == '' || duplicate_line.nil?
          duplicate_line = line
        else
          if duplicate_line != line
            raise 'More than one launchable activity in AndroidManifest' unless indicator_line.nil?
          end
        end
        indicator_line = index
      end
    end

    raise 'No launchable activity found in AndroidManifest' unless indicator_line

    intent_filter_found = false

    (0..indicator_line).reverse_each do |index|
      if intent_filter_found
        match = lines[index].match(/\s*E:\s*activity-alias/)

        raise 'Could not find target activity in activity alias' if match

        match = lines[index].match(/^\s*A:\s*android:targetActivity\(\w*\)\=\"([^\"]+)/){$1}

        if match
          log("Found launchable activity '#{match}'")

          return match
        end
      else
        unless lines[index].match(/\s*E: intent-filter/).nil?
          log("Read intent filter")
          intent_filter_found = true
        end
      end
    end

    raise 'Could not find launchable activity'
  end
end
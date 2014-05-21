class CompatabilityReader
	require 'yaml'

	def read(file_path)
		yaml_components = YAML::load_file(file_path)
		components = Array.new
		yaml_components.each_value do |y_comp|
			comp = Component.new 
			comp.controller = y_comp['controller'].to_sym
			comp.ssl_required = y_comp['ssl_required']
			components.push comp
		end

		components
	end
end
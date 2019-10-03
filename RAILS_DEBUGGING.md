```
api = Api::V1::Internal::GrimoireConfigurationController.new
ps = Lf::Projects::ProjectDataService.new
gen = ::Grimoire::Configuration::Generator.new
gen.generate(ps.find_by_slug('linux-kernel'), :projects)
p = Grimoire::Configuration::ProjectsGenerator.new
p.generate_for(ps.find_by_slug('linux-kernel'))
dsg = ::Lf::DataSources::Registry.new
dsg.list_endpoints(ps.find_by_slug('open-mainframe-project-zowe'))
```

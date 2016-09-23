directory '/tmp/chef_installer/cookbooks' do
  recursive true
end

file '/tmp/solo.rb' do
  content 'cookbook_path "/tmp/chef_installer/cookbooks"'
end

package 'git'

file '/tmp/chef_installer/Berksfile' do
  content "source 'https://supermarket.chef.io'

cookbook 'chef-server-ctl', git: 'https://github.com/stephenlauck/chef-server-ctl.git'
cookbook 'chef-services', git: 'https://github.com/stephenlauck/chef-services.git', branch: 'lauck/delivery_license'
cookbook 'chef-ingredient', git: 'https://github.com/chef-cookbooks/chef-ingredient.git'
cookbook 'test', git: 'https://github.com/stephenlauck/chef-services.git', branch: 'lauck/delivery_license', rel: 'test/fixtures/cookbooks/test'"
end

execute 'berks update' do
  command 'berks update'
  cwd '/tmp/chef_installer'
  only_if do ::File.exists?('/tmp/chef_installer/Berksfile.lock') end
end

execute 'berks install' do
  command 'berks install'
  cwd '/tmp/chef_installer'
end

execute 'berks vendor' do
  command 'berks vendor cookbooks/'
  cwd '/tmp/chef_installer'
end

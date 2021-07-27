# frozen_string_literal: true

desc 'move legacy compliance policies into books & records file storage'
task policies_to_folders: :environment do
  puts 'Moving legacy policies to folders'

  def env_path(in_path)
    Rails.env.production? || Rails.env.staging? ? in_path : "#{Rails.root}/public#{in_path}"
  end

  def create_root_folder(business)
    ne_folder = business.file_folders.where(parent_id: nil, name: 'Compliance Policies')
    folder = if ne_folder.count.positive?
               ne_folder.first
             else
               FileFolder.create(
                 business_id: business.id, parent_id: nil, name: 'Compliance Policies'
               )
             end
    folder
  end

  Business.all.each do |business|
    root_folder = create_root_folder(business)
    next unless business.compliance_policies.any?
    business.compliance_policies.each do |cp|
      next unless cp.compliance_policy_docs.any?
      ne_folder = business.file_folders.where(parent_id: root_folder.id, name: cp.title)
      cp_folder = if ne_folder.count.positive?
                    ne_folder.first
                  else
                    FileFolder.create(
                      business_id: business.id, parent_id: root_folder.id, name: cp.title
                    )
                  end
      cp.compliance_policy_docs.each do |cpd|
        doc_path = env_path(cpd.doc_url.split('?')[0])
        uploader = FileUploader.new(:store)
        file = if Rails.env.production? || Rails.env.staging?
                 URI.parse(doc_path).open
               else
                 File.open(doc_path)
               end
        uploaded_file = uploader.upload(file)
        FileDoc.create(
          business_id: business.id,
          file_folder_id: cp_folder.id,
          file_data: uploaded_file.to_json,
          name: cp.title + ' ' + cpd.created_at.strftime('%b-%-d-%Y-%H-%M') + '.' + doc_path.split('.').last
        )
      end
    end
  end
  puts 'Done moving'
end

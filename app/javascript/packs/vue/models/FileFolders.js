export default class FileFolders {
  constructor(files, folders) {
    this.files = files
    this.folders = folders
    // if (files) {
    //   for(file of files) {
    //     this.files.push({
    //       created_at: file.created_at,
    //       file_addr: file.file_addr,
    //       file_folder_id: file.file_folder_id,
    //       id: file.id,
    //       name: file.name,
    //       updated_at: file.updated_at,
    //     })
    //   }
    // }
    // if (folders) {
    //   for(folder of folders) {
    //     this.folders.push({
    //       created_at: folder.created_at,
    //       id: folder.id,
    //       locked: folder.locked,
    //       name: folder.name,
    //       parent_id: folder.parent_id,
    //       updated_at: folder.updated_at,
    //       zip_addr: folder.zip_addr,
    //     })
    //   }
    // }
  }
}


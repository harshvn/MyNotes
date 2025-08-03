class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

// C in Crud
class CouldNotCreateNoteException implements CloudStorageExceptions {}

//R in CRUD
class CouldNotGetAllNotesException implements CloudStorageExceptions {}

// U in Crud
class CouldNotUpdateNoteException implements CloudStorageExceptions {}

//D in CRUD
class CouldNotDeleteNoteException implements CloudStorageExceptions {}

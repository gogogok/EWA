import CoreData

final class Persistence {
    static let shared = Persistence()
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, err in
            if let err = err {
                print("CoreData: \(err)") }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        let ctx = container.viewContext
        do {
            try ctx.save()
        } catch {
            print(error)
        }
    }

    func wipeUserProfile() {
        let ctx = container.viewContext
        let fetch: NSFetchRequest<NSFetchRequestResult> = UserProfile.fetchRequest()
        let deleteReq = NSBatchDeleteRequest(fetchRequest: fetch)
        deleteReq.resultType = .resultTypeObjectIDs
        
        do {
            if let result = try ctx.execute(deleteReq) as? NSBatchDeleteResult,
               let ids = result.result as? [NSManagedObjectID] {
                let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: ids]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [ctx])
            }
            try ctx.save()
            ctx.refreshAllObjects()
        } catch {
            print("wipeUserPrifile error:", error)
        }
    }
    
}

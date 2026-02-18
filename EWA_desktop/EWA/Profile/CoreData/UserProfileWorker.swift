import CoreData

final class UserProfileWorker {
    private let ctx = Persistence.shared.container.viewContext
    
    func fetchAll() throws -> [UserProfile] {
        let req: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        return try ctx.fetch(req)
    }
    
    @discardableResult
    func add(userProfile: UserProfile) -> UserProfile {
        let profile = UserProfile(context: ctx)
        profile.id = userProfile.id
        profile.name = userProfile.name
        profile.email = userProfile.email
        profile.iconName = userProfile.iconName
        profile.updatedAt = userProfile.updatedAt
        Persistence.shared.save()
        return profile
    }
    
    func signInUser(id: String, email: String) {
        let fetch = UserProfile.fetchRequest()
        fetch.fetchLimit = 1
        fetch.predicate = NSPredicate(format: "id == %@", id)

        let profile = (try? ctx.fetch(fetch).first) ?? UserProfile(context: ctx)
        profile.id = id
        profile.email = email
        profile.updatedAt = Date()

        Persistence.shared.save()
    }

    func updateName(id: String, name: String) {
        let fetch = UserProfile.fetchRequest()
        fetch.fetchLimit = 1
        fetch.predicate = NSPredicate(format: "id == %@", id)

        let profile = (try? ctx.fetch(fetch).first) ?? UserProfile(context: ctx)
        profile.id = id
        profile.name = name
        profile.updatedAt = Date()

        Persistence.shared.save()
    }
    
    func updateIcon(id: String, iconName: String) {
        let fetch = UserProfile.fetchRequest()
        fetch.fetchLimit = 1
        fetch.predicate = NSPredicate(format: "id == %@", id)

        let profile = (try? ctx.fetch(fetch).first) ?? UserProfile(context: ctx)
        profile.id = id
        profile.iconName = iconName
        profile.updatedAt = Date()

        Persistence.shared.save()
    }
    
    func delete(_ profile: UserProfile) {
        ctx.delete(profile)
        try? ctx.save()
        ctx.refreshAllObjects()
    }
}

// MARK: - обёртка над репозиторием
final class UserProfileManager {
    private let repo = UserProfileWorker()
    private let ctx = Persistence.shared.container.viewContext
    
    func fetchAll() -> [UserProfile] { (try? repo.fetchAll()) ?? [] }
    func add(userProfile: UserProfile) -> UserProfile { repo.add(userProfile: userProfile) }
    func signIn(id: String, email: String) { repo.signInUser(id: id, email: email) }
    func updateName(id: String, name: String) {repo.updateName(id: id, name: name)}
    func updateIcon(id: String, iconName: String) {repo.updateIcon(id: id, iconName: iconName)}
    func delete(_ profile: UserProfile) { repo.delete(profile) }
}


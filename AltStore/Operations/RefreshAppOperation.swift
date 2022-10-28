//
//  RefreshAppOperation.swift
//  AltStore
//
//  Created by Riley Testut on 2/27/20.
//  Copyright © 2020 Riley Testut. All rights reserved.
//

import Foundation

import AltStoreCore
import AltSign
import Roxas
import minimuxer

@objc(RefreshAppOperation)
class RefreshAppOperation: ResultOperation<InstalledApp>
{
    let context: AppOperationContext
    
    // Strong reference to managedObjectContext to keep it alive until we're finished.
    let managedObjectContext: NSManagedObjectContext
    
    init(context: AppOperationContext)
    {
        self.context = context
        self.managedObjectContext = DatabaseManager.shared.persistentContainer.newBackgroundContext()
        
        super.init()
    }
    
    override func main()
    {
        super.main()
        
        do
        {
            if let error = self.context.error
            {
                throw error
            }
            
            guard let profiles = self.context.provisioningProfiles else { throw OperationError.invalidParameters }
            
            guard let app = self.context.app else { throw OperationError.appNotFound }
            
            DatabaseManager.shared.persistentContainer.performBackgroundTask { (context) in
                print("Sending refresh app request...")
                
                let activeProfiles: Set<String>?
                if UserDefaults.standard.activeAppsLimit != nil
                {
                    // When installing these new profiles, AltServer will remove all non-active profiles to ensure we remain under limit.
                    let activeApps = InstalledApp.fetchActiveApps(in: context)
                    activeProfiles = Set(activeApps.flatMap { (installedApp) -> [String] in
                        let appExtensionProfiles = installedApp.appExtensions.map { $0.resignedBundleIdentifier }
                        return [installedApp.resignedBundleIdentifier] + appExtensionProfiles
                    })
                }
                
                print("HERE\n\n\n")
                print(profiles)
                print("\n\n\n")
                for p in profiles {
                    do {
                        try install_provisioning_profile(plist: p.value.data)
                    } catch {
                        self.finish(.failure(Uhoh.Bad))
                    }
                    self.progress.completedUnitCount += 1
                    
                    let predicate = NSPredicate(format: "%K == %@", #keyPath(InstalledApp.bundleIdentifier), app.bundleIdentifier)
                    self.managedObjectContext.perform {
                        guard let installedApp = InstalledApp.first(satisfying: predicate, in: self.managedObjectContext) else {
                            return
                        }
                        installedApp.update(provisioningProfile: p.value)
                        self.finish(.success(installedApp))
                    }
                }
            }
        }
        catch
        {
            self.finish(.failure(error))
        }
    }
}

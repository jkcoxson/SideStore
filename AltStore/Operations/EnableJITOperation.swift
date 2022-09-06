//
//  EnableJITOperation.swift
//  EnableJITOperation
//
//  Created by Riley Testut on 9/1/21.
//  Copyright © 2021 Riley Testut. All rights reserved.
//

import UIKit
import Combine

import AltStoreCore

@available(iOS 14, *)
protocol EnableJITContext
{
    var server: Server? { get }
    var installedApp: InstalledApp? { get }
    
    var error: Error? { get }
}

@available(iOS 14, *)
class EnableJITOperation<Context: EnableJITContext>: ResultOperation<Void>
{
    let context: Context
    
    private var cancellable: AnyCancellable?
    
    init(context: Context)
    {
        self.context = context
    }
    
    override func main()
    {
        super.main()
        
        if let error = self.context.error
        {
            self.finish(.failure(error))
            return
        }
        
        guard let installedApp = self.context.installedApp else { return self.finish(.failure(OperationError.invalidParameters)) }
        
        installedApp.managedObjectContext?.perform {
            
            let id = NSString(string: installedApp.resignedBundleIdentifier)
            let id_ptr = UnsafeMutablePointer<CChar>(mutating: id.utf8String)
            
            minimuxer_debug_app(id_ptr)
        }
    }
}

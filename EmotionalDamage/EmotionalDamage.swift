//
//  EmotionalDamage.swift
//  EmotionalDamage
//
//  Created by Jackson Coxson on 10/26/22.
//

import Foundation

public class EmotionalDamage {
    var handle: UnsafeMutableRawPointer
    public init(bind_addr: String) {
        let host = NSString(string: bind_addr)
        let host_pointer = UnsafeMutablePointer<CChar>(mutating: host.utf8String)
        self.handle = start_emotional_damage(host_pointer)
    }
    
    public func stop() {
        stop_emotional_damage(self.handle)
    }
}

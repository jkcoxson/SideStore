//
//  minimuxer.swift
//  minimuxer
//
//  Created by Jackson Coxson on 10/27/22.
//

import Foundation

public enum Uhoh: Error {
    case Good
    case Bad
}

public func start_minimuxer(pairing_file: String) {
    let pf = NSString(string: pairing_file)
    let pf_pointer = UnsafeMutablePointer<CChar>(mutating: pf.utf8String)
    minimuxer_c_start(pf_pointer)
}

public func set_usbmuxd_socket() {
    target_minimuxer_address()
}

public func debug_app(app_id: String) throws -> Uhoh {
    let ai = NSString(string: app_id)
    let ai_pointer = UnsafeMutablePointer<CChar>(mutating: ai.utf8String)
    if minimuxer_debug_app(ai_pointer) == -1 {
        throw Uhoh.Bad
    }
    return Uhoh.Good
}

public func install_provisioning_profile(plist: Data) throws -> Uhoh {
    let pls = String(decoding: plist, as: UTF8.self)
    print(pls)
    print(plist)
    let x = plist.withUnsafeBytes { buf in UnsafeMutableRawPointer(mutating: buf) }
    if minimuxer_install_provisioning_profile(x, UInt32(plist.count)) != 0 {
        throw Uhoh.Bad
    }
    return Uhoh.Good
}

public func remove_provisioning_profile(id: String) throws -> Uhoh {
    let id_ns = NSString(string: id)
    let id_pointer = UnsafeMutablePointer<CChar>(mutating: id_ns.utf8String)
    if minimuxer_remove_provisioning_profile(id_pointer) != 0 {
        throw Uhoh.Bad
    }
    return Uhoh.Good
}

public func remove_app(app_id: String) throws -> Uhoh {
    let ai = NSString(string: app_id)
    let ai_pointer = UnsafeMutablePointer<CChar>(mutating: ai.utf8String)
    if minimuxer_remove_app(ai_pointer) == -1 {
        throw Uhoh.Bad
    }
    return Uhoh.Good
}

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

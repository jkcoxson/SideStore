//
//  minimuxer.swift
//  minimuxer
//
//  Created by Jackson Coxson on 10/27/22.
//

import Foundation

public func start_minimuxer(pairing_file: String) {
    let pf = NSString(string: pairing_file)
    let pf_pointer = UnsafeMutablePointer<CChar>(mutating: pf.utf8String)
    minimuxer_c_start(pf_pointer)
}

public func set_usbmuxd_socket() {
    target_minimuxer_address()
}

//
//  EnvironmentVariables.swift
//  MenugrabAppClip
//
//  Created by Guillermo Alfonso Varela Chouciño on 13/04/2021.
//

import Foundation

enum EnvironmentVariables {
    private static let env = ProcessInfo.processInfo.environment
    
    static let CHECK_USER_LOCATION_DISABLED = env["CHECK_USER_LOCATION_DISABLED"] != nil
}

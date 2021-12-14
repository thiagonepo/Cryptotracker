//
//  main.swift
//  CryptoTracker
//
//  Created by Thiago Nepomuceno Silva on 30/11/21.
//

import UIKit

let appDelegateClass: AnyClass = NSClassFromString("TestAppDelegate") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc,
                  CommandLine.unsafeArgv,
                  nil, NSStringFromClass(appDelegateClass))

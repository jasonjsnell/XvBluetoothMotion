//
//  XvBluetoothMotion.swift
//  XvBluetoothMotion
//
//  Created by Jason Snell on 5/17/17.
//  Copyright © 2017 Jason J. Snell. All rights reserved.
//

/*

 DESIGN:
 
 Main file:
 This file is the overall manager, a singleton. This is the access point to the framework.
 
 Listerer file:
 Listeners are individual objects, each one listens to it's own bluetooth device in scenarios where there are multiple
 
 The listener is init'd with the UUID's of the service and motion characteritics. Each bluetooth device needs to be programmed to at least have unique service UUID's
 
 The listeners handle their own Bluetooth manager and peripheral functions, from discovery to notification listening
 
 When a listener "hears" incoming motion data, it will post a Notification so listeners in the app can receive the notification, unpack its service UUID, characteristic UUID, and value. This way it can determine which board the motion value came
 
 Utils file:
 helpers for the Listener object
 
 SampleArduinoCode file:
 Code that can be used on an Aruduino 101 Curie Board (as of May 2017)
 
 */

/*
 

 addListener(serviceUUID: service, xCharUUID: x, yCharUUID: y, zCharUUID: z)
 
 */


import Foundation
import CoreBluetooth

public class XvBluetoothMotion {
    
    //vars
    fileprivate var listeners:[Listener] = []
    
    //singleton code
    public static let sharedInstance = XvBluetoothMotion()
    fileprivate init() {}
    
    public func addListener(serviceUUID:CBUUID, xCharUUID:CBUUID, yCharUUID:CBUUID, zCharUUID:CBUUID){
        
        let listener:Listener = Listener(
            serviceUUID: serviceUUID,
            xCharUUID: xCharUUID,
            yCharUUID: yCharUUID,
            zCharUUID: zCharUUID
        )
        
        listeners.append(listener)
        
    }
    
    public func connect(){
        
        print("MOTION: Connect to", listeners.count, "listeners")
        
        for listener in listeners {
            listener.connect()
        }
    }
    
    public func disconnect(){
        
        for listener in listeners {
            listener.disconnect()
        }
    
    }

}


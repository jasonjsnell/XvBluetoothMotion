//
//  Utils.swift
//  XvBluetoothMotion
//
//  Created by Jason Snell on 5/17/17.
//  Copyright © 2017 Jason J. Snell. All rights reserved.
//

import Foundation
import CoreBluetooth

class Utils {
    
    
    //MARK: - NOTIFICATIONS
    // post notification to class listening to this framework
    
    class func postNotification(name:String, userInfo:[AnyHashable : Any]?){
        
        let notification:Notification.Name = Notification.Name(rawValue: name)
        NotificationCenter.default.post(
            name: notification,
            object: nil,
            userInfo: userInfo)
    }
    
    //MARK: - CONVERSION
    // converts data type to Int32 types
    // used to convert incoming values from bluetooth device
    class func getInt(fromData:Data) ->Int32 {
        
        let value = fromData.withUnsafeBytes { (ptr: UnsafePointer<Int32>) -> Int32 in
            return ptr.pointee
        }
        return value
    }
    
    //MARK: - DEBUG
    // debugs the type of incoming characteristic
    
    class func printType(forCharacteristic:CBCharacteristic){
        
        if forCharacteristic.properties.contains(.broadcast) {
            print("MOTION: Characteristic type: broadcast")
        }
        
        if forCharacteristic.properties.contains(.read) {
            print("MOTION: Characteristic type: read")
        }
        
        if forCharacteristic.properties.contains(.writeWithoutResponse) {
            print("MOTION: Characteristic type: writeWithoutResponse")
        }
        
        if forCharacteristic.properties.contains(.write) {
            print("MOTION: Characteristic type: write")
        }
        
        if forCharacteristic.properties.contains(.notify) {
            print("MOTION: Characteristic type: notify")
        }
        
        if forCharacteristic.properties.contains(.indicate) {
            print("MOTION: Characteristic type: indicate")
        }
        
        if forCharacteristic.properties.contains(.authenticatedSignedWrites) {
            print("MOTION: Characteristic type: authenticatedSignedWrites")
        }
        
        if forCharacteristic.properties.contains(.extendedProperties) {
            print("MOTION: Characteristic type: extendedProperties")
        }
        
        if forCharacteristic.properties.contains(.notifyEncryptionRequired) {
            print("MOTION: Characteristic type: notifyEncryptionRequired")
        }
        
        if forCharacteristic.properties.contains(.indicateEncryptionRequired) {
            print("MOTION: Characteristic type: indicateEncryptionRequired")
        }
        
    }
    
    


}

//
//  Listener.swift
//  XvBluetoothMotion
//
//  Created by Jason Snell on 5/22/17.
//  Copyright © 2017 Jason J. Snell. All rights reserved.
//

/*
 Listener object that listens to an indivdual Arduino bluetooth board
 */

import CoreBluetooth

class Listener:NSObject {
    
    //bluetooth objects
    fileprivate var _centralManager: CBCentralManager!
    fileprivate var _peripheral: CBPeripheral?
    fileprivate var _service: CBService?
    
    //ID's passed in from app, correspond to id's coming from Arduino board
    fileprivate var _serviceUUID:CBUUID?
    fileprivate var _xCharUUID:CBUUID?
    fileprivate var _yCharUUID:CBUUID?
    fileprivate var _zCharUUID:CBUUID?
    
    //motion characteristics coming in from the device
    fileprivate var _xCharacteristic: CBCharacteristic?
    fileprivate var _yCharacteristic: CBCharacteristic?
    fileprivate var _zCharacteristic: CBCharacteristic?
    
    //the time a scan is performed before giving up
    fileprivate var scanTimer:Timer = Timer()
    fileprivate let SCAN_DURATION:TimeInterval = 10.0

    fileprivate let debug:Bool = true
    
    init(
        serviceUUID: CBUUID,
        xCharUUID: CBUUID,
        yCharUUID: CBUUID,
        zCharUUID: CBUUID){
        
        super.init()
        
        //capture IDs
        _serviceUUID = serviceUUID
        _xCharUUID = xCharUUID
        _yCharUUID = yCharUUID
        _zCharUUID = zCharUUID
        
        //init bluetooth
        _centralManager = CBCentralManager(delegate: self, queue: nil)
    
    }

    internal func connect(){
        
        //init connection
        disconnect()
        
        //scan for new peripherals
        _centralManager.scanForPeripherals(withServices: [_serviceUUID!], options: nil)
        
        //_centralManager.scanForPeripherals(withServices: nil, options: nil) //scans for all bluetooth devices in area
        
        //start scanning timer so scan doesn't happen indefinitely
        scanTimer = Timer.scheduledTimer(
            timeInterval: SCAN_DURATION,
            target: self,
            selector: #selector(scanEnded),
            userInfo: nil,
            repeats: false)
    }
    
    internal func disconnect(){
        
        //cancel timer
        scanTimer.invalidate()
        
        //stop scan if one is occurring
        if (_centralManager.isScanning){
            _centralManager.stopScan()
        }
        
        //release peripheral if one is connected
        if (_peripheral != nil){
            _centralManager.cancelPeripheralConnection(_peripheral!)
        }
        
    }
    
    internal func scanEnded(){
        
        //stop timer and scan
        scanTimer.invalidate()
        _centralManager.stopScan()
        
        //output no device found if debugging
        if (debug && _serviceUUID != nil){
            print("MOTION: Scan found no devices with service ID", _serviceUUID!)
        }
        
    }
    
    
}

//MARK: - CENTRAL MANAGER FUNCTIONS -
extension Listener: CBCentralManagerDelegate {
    
    //MARK: State change, power on, off, etc...
    
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        //output status during debugging
        
        if (debug){
            switch central.state {
                
            case .poweredOn:
                print("MOTION: Bluetooth on this device is currently powered on.")
            case .poweredOff:
                print("MOTION: Bluetooth on this device is currently powered off.")
            case .unsupported:
                print("MOTION: This device does not support Bluetooth Low Energy.")
            case .unauthorized:
                print("MOTION: This app is not authorized to use Bluetooth Low Energy.")
            case .resetting:
                print("MOTION: The BLE Manager is resetting; a state update is pending.")
            case .unknown:
                print("MOTION: The state of the BLE Manager is unknown.")
                
            }
        }
        
    }
    
    
    
    //MARK: A peripheral with the service ID was discovered
    internal func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if (debug){
            print("MOTION: Peripheral discovered = ", peripheral)
            print("MOTION: Advertisement Data = ", advertisementData as Dictionary)
            print("")
        }
    
        _peripheral = peripheral //retain ref
        
        if let _peripheral = _peripheral {
            
            //set delegate to self (which is the peripheral code extension below)
            _peripheral.delegate = self
            
            //attempt to connect to the newly discovered peripheral
            _centralManager.connect(_peripheral, options: nil)
            
            //stop the scan
            scanTimer.invalidate()
            _centralManager.stopScan()
            
        } else {
            print("MOTION: Error getting connecting to peripheral")
        }
   
    }
    
    //MARK: Did connect to the peripheral
    internal func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        // Connection was successful, now search for services
        // (which takes us down to the code extension below for peripherals)
        
        if (debug){ print("MOTION: Connected to peripheral") }
        if (_peripheral != nil){
            _peripheral!.discoverServices(nil)
        }
        
    }
    
    
}

//MARK: - PERIPHERAL FUNCTIONS -
extension Listener: CBPeripheralDelegate {
    
    //MARK: Services were discovered
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if (_peripheral != nil){
            
            guard let services:[CBService] = _peripheral!.services else {
                return
            }
        
            //search for services on peripheral
            for service in services{
                
                if (debug){
                    print("MOTION: Discovered service =", service)
                }
                
                //capture the service from the device
                _service = service
                
                //search for its characteristics
                _peripheral!.discoverCharacteristics(nil, for: service)
                
            }
        } else {
            print("MOTION: Peripheral is nil during didDiscoverServices")
        }
    }
    
    //MARK: Characteristics were discovered
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if (_service != nil){
            guard let characteristics:[CBCharacteristic] = _service!.characteristics else {
                return
            }
            
            if (debug){
                print("MOTION:", characteristics.count, "characteristics found")
            }
            
            //loop through and capture the characteristics that match the incoming IDs from the app
            for characteristic in characteristics {
                
                Utils.printType(forCharacteristic: characteristic)
                
                if (characteristic.uuid == _xCharUUID){
                    _xCharacteristic = characteristic
                    peripheral.setNotifyValue(true, for: _xCharacteristic!)
                } else if (characteristic.uuid == _yCharUUID){
                    _yCharacteristic = characteristic
                    peripheral.setNotifyValue(true, for: _yCharacteristic!)
                } else if (characteristic.uuid == _zCharUUID){
                    _zCharacteristic = characteristic
                    peripheral.setNotifyValue(true, for: _zCharacteristic!)
                }
            }
        } else {
            print("MOTION: Service ID is nil during didDiscoverCharacteristicsFor")
        }
    }
    
    //MARK: Value updates from the connected device
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if (_serviceUUID != nil){
            
            let valueAsData:Data = characteristic.value!
            let valueAsInt:Int32 = Utils.getInt(fromData: valueAsData)
            
            Utils.postNotification(
                name: XvBluetoothMotionConstants.kXvBluetoothMotionReceived,
                userInfo: [
                    "serviceUUID" : _serviceUUID!,
                    "characteristicUUID" : characteristic.uuid,
                    "value" : valueAsInt])
            
        } else {
            print("MOTION: Service ID is nil during didUpdateValue")
        }
        
    }
    
}


//
//  SampleArduinoCode.swift
//  XvBluetoothMotion
//
//  Created by Jason Snell on 5/17/17.
//  Copyright © 2017 Jason J. Snell. All rights reserved.
//

import Foundation

/*
//Sample Arudion 101 Board (with built in Bluetooth and accelerometer) code to broadcast its motion data
 
 #include <CurieIMU.h>
 #include <CurieBLE.h>
 
 float accelScale;
 int roll, pitch, heading;
 int prevX, prevY, prevZ;
 int currX, currY, currZ;
 bool toggle;
 
 // create service for motion detection
 // UUID generated at https://www.uuidgenerator.net/version1
 BLEService motionService("9aa27fbb-d530-414d-9442-9b2752596350");
 
 BLEIntCharacteristic xChar("1d12666b-8d44-4243-a726-142c761e4075", BLENotify);
 BLEIntCharacteristic yChar("94a72dc3-27cd-4f03-8416-27daa8c5c716", BLENotify);
 BLEIntCharacteristic zChar("1b91411d-c79f-49a7-bc1d-98c8a95ae6a7", BLENotify);
 
 
 void setup() {
 
    toggle = true;
 
    Serial.begin(9600); // initialize Serial communication
 
    // init BLE
    BLE.begin();
    // set the local name peripheral advertises
    BLE.setLocalName("MotionDetector");
    // set the UUID for the service this peripheral advertises:
    BLE.setAdvertisedService(motionService);
 
    // add the characteristics to the service
    motionService.addCharacteristic(xChar);
    motionService.addCharacteristic(yChar);
    motionService.addCharacteristic(zChar);
 
    // add the service
    BLE.addService(motionService);
 
    //init chars
    xChar.setValue(0);
    xChar.setValue(0);
    yChar.setValue(0);
 
    // start advertising
    BLE.advertise();
 
    Serial.println("Bluetooth device active, waiting for connections...");
 
    // start the IMU and filter
    CurieIMU.begin();
    CurieIMU.setGyroRate(25);
    CurieIMU.setAccelerometerRate(25);
 
    // Set the accelerometer range to 2G
    CurieIMU.setAccelerometerRange(2);
    // Set the gyroscope range to 250 degrees/second
    CurieIMU.setGyroRange(250);
 
 }
 
 // board cannot detect motion data and send it via Bluetooth in the same loop, so a toggle switch is set so it goes back and forth between these functions.
 
 void loop() {
 
    if (toggle) {
        // Collect data from Arduino
        int aix, aiy, aiz;
        int gix, giy, giz;
 
        // read raw data from CurieIMU
        CurieIMU.readMotionSensor(aix, aiy, aiz, gix, giy, giz);
 
        // convert from raw data to gravity and degrees/second units
        currX = (int)convertRawAcceleration(aix);
        currY = (int)convertRawAcceleration(aiy);
        currZ = (int)convertRawAcceleration(aiz);
 
 
        Serial.print("Orientation: ");
        Serial.print(currX);
        Serial.print(" ");
        Serial.print(currY);
        Serial.print(" ");
        Serial.println(currZ);
 
        toggle = false;
 
    } else {
 
        // Transmit data over bluetooth if values have changed
 
        if (currX != prevX){
            xChar.setValue(currX);
            prevX = currX;
        }
 
        if (currY != prevY){
            yChar.setValue(currY);
            prevY = currY;
        }
 
        if (currZ != prevZ){
            zChar.setValue(currZ);
            prevZ = currZ;
        }
 
        toggle = true;
 
    }
 
    delay(25);
 
 }
 
 float convertRawAcceleration(int aRaw) {
    // since we are using 2G range
    // -2g maps to a raw value of -32768
    // +2g maps to a raw value of 32767
 
    float a = (aRaw * 2.0) / 32768.0;
    return a;
 }

 
 */

//
//  Smart Listener.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 8.08.2021.
//

import Foundation
import AVFAudio

final class SmartListener:NSObject{
    weak var delegate : SmartListenerDelegate?
    private let fileManager = FileManager.default
    private let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private lazy var tresholdLevel:Float = -30
    private var recorder : AVAudioRecorder!
    private var resultTimer:Timer?
    private var isActive:Bool = false
    
    override init() {
        super.init()
        setListener()
    }
    
    deinit{
        print("smart listener deinit")
    }
    
    private func setListener(){
        let url = documentsUrl.appendingPathComponent("record.caf")
        let recordSettings: [String: Any] = [
            AVFormatIDKey:              kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      1,
            AVEncoderBitRateKey:        12800,
            AVLinearPCMBitDepthKey:     16,
            AVEncoderAudioQualityKey:   AVAudioQuality.min.rawValue
        ]
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord)
            try audioSession.setActive(true)
            try recorder = AVAudioRecorder(url:url, settings: recordSettings)
        } catch {
            return
        }
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
    }
}

extension SmartListener:SmartListenerProtocol{
    func deleteAllTimer() {
        resultTimer?.invalidate()
    }
    
    func stopToListen(){
       isActive = false
        recorder.stop()
        
    }
    
    func startToListen(){
        //check to prevent session I/O error
        isActive = true
        //reset timers
        resultTimer?.invalidate()
        recorder.prepareToRecord()
        recorder.record()
        recorder.isMeteringEnabled = true
        //control is there any sound
        resultTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
    }
    
    @objc private func levelTimerCallback() {
        recorder.updateMeters()
        let level = recorder.averagePower(forChannel: 0)
        if level <  -80.0 {
            stopToListen()
            startToListen()
            return
        }
        tresholdLevel = delegate?.setSoundLevel() ?? tresholdLevel
        let isLoud = level > tresholdLevel
        // do whatever you want with isLoud
        if isLoud{
            delegate?.thereIsSoundAround()
        }
    }
}


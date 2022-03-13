//
//  WhiteNoisePlayer.swift
//  BabyWalkieTalkie
//
//  Created by Mehmet fatih DOĞAN on 2.03.2022.
//

import Foundation
import AVFoundation

protocol SoundPlayerProtocol {
    func playSound()
    func stopSound()
}
protocol SoundPlayerDelegate:AnyObject {
    func errorType(_ error:SoundPlayerError )
}

enum SoundPlayerError:Error{
    case bundleError
    case playerError
}

class SoundPlayer: NSObject {
    var player :AVAudioPlayer!
    weak var delegate:SoundPlayerDelegate?
    public override init(){
        super.init()
        guard let url = Bundle.main.url(forResource: "WhiteNoise", withExtension: "mp3") else {delegate?.errorType(.bundleError);return}
        do {
            print(url)
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                   try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player.delegate = self
        } catch {
            delegate?.errorType(.playerError)
        }
    }
}

extension SoundPlayer:SoundPlayerProtocol,AVAudioPlayerDelegate {
    func playSound() {
        guard let player = player else { return }
        player.prepareToPlay()
        player.play()
    }
    
    func stopSound() {
        player.stop()
    }
    
}

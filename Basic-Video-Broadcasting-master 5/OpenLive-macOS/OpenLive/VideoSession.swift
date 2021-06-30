//
//  VideoSession.swift
//  OpenLive
//
//  Created by GongYuhua on 3/28/16.
//  Copyright © 2016 Agora. All rights reserved.
//

import Cocoa

import AgoraRtcKit

class VideoSession: NSObject {
    enum SessionType {
        case local, remote
        
        var isLocal: Bool {
            switch self {
            case .local:  return true
            case .remote: return false
            }
        }
    }
    
    var isVideoMuted = false {
        didSet {
            hostingView.isVideoMuted = isVideoMuted
        }
    }
    
    private (set)var uid: UInt
    private (set)var hostingView: VideoView!
    private (set)var canvas: AgoraRtcVideoCanvas
    private (set)var type: SessionType
    
    var descriptionType: StatisticsInfo.DescriptionContent = .full {
        didSet {
            hostingView.descriptionType = descriptionType
            hostingView.update(with: statistics)
        }
    }
    
    var statistics: StatisticsInfo
    
    init(uid: UInt, type: SessionType = .remote) {
        self.uid = uid
        self.type = type
        
        hostingView = VideoView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        hostingView.wantsLayer = true
        
        canvas = AgoraRtcVideoCanvas()
        canvas.uid = uid
        canvas.view = hostingView.videoView
        canvas.renderMode = .hidden
        
        switch type {
        case .local:  statistics = StatisticsInfo(type: StatisticsInfo.StatisticsType.local(StatisticsInfo.LocalInfo()))
        case .remote: statistics = StatisticsInfo(type: StatisticsInfo.StatisticsType.remote(StatisticsInfo.RemoteInfo()))
        }
    }
}

extension VideoSession {
    static func localSession() -> VideoSession {
        return VideoSession(uid: 0, type: .local)
    }
    
    func updateInfo(resolution: CGSize? = nil, fps: Int? = nil, txQuality: AgoraNetworkQuality? = nil, rxQuality: AgoraNetworkQuality? = nil) {
        if let resolution = resolution {
            statistics.dimension = resolution
        }
        
        if let fps = fps {
            statistics.fps = fps
        }
        
        if let txQuality = txQuality {
            statistics.txQuality = txQuality
        }
        
        if let rxQuality = rxQuality {
            statistics.rxQuality = rxQuality
        }
        
        hostingView.update(with: statistics)
    }
    
    func updateChannelStats(_ stats: AgoraChannelStats) {
        guard self.type.isLocal else {
            return
        }
        statistics.updateChannelStats(stats)
        hostingView.update(with: statistics)
    }
    
    func updateVideoStats(_ stats: AgoraRtcRemoteVideoStats) {
        guard !self.type.isLocal else {
            return
        }
        statistics.fps = Int(stats.rendererOutputFrameRate)
        statistics.dimension = CGSize(width: CGFloat(stats.width), height: CGFloat(stats.height))
        statistics.updateVideoStats(stats)
        hostingView.update(with: statistics)
    }
    
    func updateAudioStats(_ stats: AgoraRtcRemoteAudioStats) {
        guard !self.type.isLocal else {
            return
        }
        statistics.updateAudioStats(stats)
        hostingView.update(with: statistics)
    }
}

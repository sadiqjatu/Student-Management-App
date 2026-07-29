//
//  AttentionRecord.swift
//  Student-Management-App
//
//  Created by Sadiq Jatu on 26/07/26.
//

import Foundation

struct AttentionRecord {
    let studentName: String
    let value: String
    let issueType: AttentionIssueType
}


enum AttentionIssueType {
    case attendance
    case grade
}


struct TopCardData {
    let type: TopCardType
    let value: String
}


struct MetricData {
    let type: MetricType
    let value: String
}

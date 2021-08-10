//
//  AlertModel.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/10.
//


struct Alert: Codable {
    let senderName, event: String
    let start, end: Int
    let alertDescription: String
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case event, start, end
        case alertDescription = "description"
        case tags
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        senderName = (try? value.decode(String.self, forKey: .senderName)) ?? ""
        event = (try? value.decode(String.self, forKey: .event)) ?? ""
        start = (try? value.decode(Int.self, forKey: .start)) ?? 0
        end = (try? value.decode(Int.self, forKey: .end)) ?? 0
        alertDescription = (try? value.decode(String.self, forKey: .alertDescription)) ?? ""
        tags = (try? value.decode([String].self, forKey: .tags)) ?? []
    }
}

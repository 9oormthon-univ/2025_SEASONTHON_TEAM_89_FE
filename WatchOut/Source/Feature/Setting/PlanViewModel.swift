//
//  PlanViewModel.swift
//  WatchOut
//
//  Created by 어재선 on 11/8/25.
//

import Foundation

class PlanViewModel: ObservableObject {
    @Published var selectedType: PlanType = .individual
    @Published var selectedPlan: String = ""
    @Published var isCurrentlyUsed: String = Individual.basic.rawValue
}

//
//  AnalysisView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/30/24.
//

import SwiftUI

struct AnalysisView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    var body: some View {
        
        VStack {
            Text("Front Analysis: \(viewModel.frontAnalysis)")
            Text("Back Analysis: \(viewModel.backAnalysis)")
        }
        
    }
    
}

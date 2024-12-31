//
//  AnalysisView.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/30/24.
//

import SwiftUI

struct AnalysisView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    
    //want to turn Front and Back analysis from JSON to struct so that we can
    
    //We will eventually embed this view in ScanView, for the user to easily see
    var body: some View {
        ScrollView {
            //display analysis results here
           
            VStack {
                
                //Body Fat Percentage and Overall Muscle Development Rating
                HStack {
                    Text("Estimated Front BF%: \(viewModel.frontAnalysis?.bodyFatPercentage ?? 0)")
                    Text("Estimated Back BF%: \(viewModel.backAnalysis?.bodyFatPercentage ?? 0)")
                }
                
                //Upper Body Muscle Ratings
                HStack {
                    Text("Shoulders Rating: \(viewModel.frontAnalysis?.shoulders?.rating ?? 0)")
                    Text("Chest Rating: \(viewModel.frontAnalysis?.chest?.rating ?? 0)")
                    Text("Arms Rating: \(viewModel.frontAnalysis?.arms?.rating ?? 0)")
                    Text("Abs Rating: \(viewModel.frontAnalysis?.abs?.rating ?? 0)")
                }
                
                //Lower Body Muscle Ratings
                HStack {
                    
                }
                
                //Muscle Highlights
                HStack {
                    
                }
                
            
                
                
            }
        
            
        }
       
    }
    
}

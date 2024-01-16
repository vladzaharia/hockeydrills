//
//  DrillsView.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/12/24.
//

import SwiftUI

struct DrillStepView: View {
    @EnvironmentObject var drillManager: DrillManager
    @EnvironmentObject var settingsManager: SettingsManager
    
    @State var showSkipModal: Bool = false {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut) {
                    self.showSkipModal = false
                }
            }
        }
    }
    
    @State var showCompleteModal: Bool = false {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut) {
                    self.showCompleteModal = false
                }
            }
        }
    }
    
    @State var showCongratulationsModal: Bool = false {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut) {
                    self.showCongratulationsModal = false
                }
            }
        }
    }
        
    var body: some View {
        ZStack {
            if showCongratulationsModal {
                VStack {
                    Image(systemName: "party.popper.fill")
                        .font(.system(.largeTitle, design: .rounded))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                    
                    Text("Woohoo!")
                        .font(.system(.title2, design: .rounded))
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 1, trailing: 20))
                        .multilineTextAlignment(.center)
                    Text("You completed a set!")
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .multilineTextAlignment(.center)
                }
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Color.blue.gradient)
                .foregroundStyle(Color.black.gradient)
            } else if showCompleteModal {
                VStack {
                    Image(systemName: "checkmark")
                        .font(.system(.largeTitle, design: .rounded))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                    
                    Text("Completed Step")
                        .font(.system(.title2, design: .rounded))
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .multilineTextAlignment(.center)
                }
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Color.green.gradient)
                .foregroundStyle(Color.black.gradient)
            } else if showSkipModal {
                VStack {
                    Image(systemName: "arrowshape.zigzag.right")
                        .font(.system(.largeTitle, design: .rounded))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                    
                    Text("Skipped Step")
                        .font(.system(.title2, design: .rounded))
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .multilineTextAlignment(.center)
                }
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Color.orange.gradient)
                .foregroundStyle(Color.black.gradient)
            } else if drillManager.currentStep == nil {
                VStack {
                    Image(systemName: "exclamationmark.octagon")
                        .font(.system(.title, design: .rounded))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                    
                    Text("No drills available!")
                        .font(.system(.title3, design: .rounded))
                        .multilineTextAlignment(.center)
                }
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Color.red.gradient)
                .foregroundStyle(Color.black.gradient)
            } else {
                VStack {
                    HStack(alignment: .lastTextBaseline) {
                        Text(((drillManager.currentStep?.qty ?? 0).formatted(.number.precision(.fractionLength(0)))) + "x").foregroundStyle(Color.blue.gradient).font(.system(.title2, design: .rounded)
                            .monospacedDigit()
                            .lowercaseSmallCaps()
                        )
                        Spacer()
                        Text(drillManager.currentStep?.text ?? "").font(.system(.title3, design: .rounded)).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                    
                    Spacer()
                    
                    Text(drillManager.currentStep?.descriptor ?? "")
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    
                    if settingsManager.showCompleteButton {
                        Button {
                            withAnimation(.easeInOut) {
                                showCompleteModal = true
                                drillManager.completeStep()
                            }
                        } label: {
                            Image(systemName: "checkmark")
                        }
                        .tint(Color.blue)
                        .font(.title2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onChange(of: drillManager.currentStep) {
            if (drillManager.numberCompleted % drillManager.selectedDrill!.steps.count == 0) {
                withAnimation(.easeInOut) {
                    showCongratulationsModal = true
                }
            }
        }
        .transition(.slide)
    }
}

#Preview {
    DrillStepView()
        .environmentObject(DrillManager())
}

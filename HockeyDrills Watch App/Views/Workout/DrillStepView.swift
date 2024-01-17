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
                        .fontWeight(.medium)
                    Text("You completed a set!")
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .multilineTextAlignment(.center)
                        .fontWeight(.medium)
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
                        .fontWeight(.bold)

                    Text("Completed Step")
                        .font(.system(.title2, design: .rounded))
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .multilineTextAlignment(.center)
                        .fontWeight(.medium)
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
                        .fontWeight(.medium)
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
                        .fontWeight(.medium)
                }
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .foregroundStyle(Color.red.gradient)
            } else {
                VStack {
                    HStack(alignment: .lastTextBaseline) {
                        Text(((drillManager.currentStep?.qty ?? 0)
                            .formatted(.number.precision(.fractionLength(0)))) + "x")
                        .foregroundStyle(Color.blue.gradient).font(.system(.title2, design: .rounded)
                            .monospacedDigit()
                            .lowercaseSmallCaps()
                        )
                        
                        Spacer(minLength: 10)
                        
                        Text(drillManager.currentStep?.text ?? "")
                            .font(.system(size: 22, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Text(drillManager.currentStep?.modifier ?? "")
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .foregroundStyle(Color.gray)
                    
                    Divider()
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    
                    VStack {
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
                            .font(.title3)
                            .fontWeight(.semibold)
                        } else {
                            Text(drillManager.currentStep?.instruction ?? "")
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onChange(of: drillManager.currentStep) {
            if (drillManager.numberCompleted != 0 && drillManager.numberCompleted % drillManager.selectedDrill!.steps.count == 0) {
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

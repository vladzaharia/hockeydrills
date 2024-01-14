//
//  DrillsView.swift
//  HockeyDrills Watch App
//
//  Created by Vlad Zaharia on 1/12/24.
//

import SwiftUI

struct DrillStepView: View {
    @Environment(DrillManager.self) var drillManager: DrillManager
        
    var body: some View {
        if (drillManager.currentStep == nil) {
            VStack {
                Image(systemName: "exclamationmark.octagon")
                    .font(.system(.title, design: .rounded))
                    .foregroundStyle(Color.red.gradient)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                
                Text("No drills available!")
            }
        } else {
            VStack {
                HStack(alignment: .lastTextBaseline) {
                    Text((drillManager.currentStep?.qty.formatted(.number.precision(.fractionLength(0))) ?? "0") + "x").foregroundStyle(Color.blue.gradient).font(.system(.title2, design: .rounded)
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
                
                Button {
                    drillManager.completeStep()
                } label: {
                    Image(systemName: "checkmark")
                }
                .tint(Color.blue)
                .font(.title2)
                .onLongPressGesture {
                    drillManager.skipStep()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    DrillStepView()
        .environment(DrillManager())
}

//
//  AttackBuildingView.swift
//  FoeHelper
//
//  Created by George Karavas on 12/7/21.
//

import SwiftUI

struct AttackBuildingView: View {
    @EnvironmentObject var sharedData: SharedData

    @State private var levelPoints: String = ""
    @State private var totalBuildingPoints: String = ""
    @State private var currentPositionPoints: String = ""
    @State private var positionReturnPoints: String = ""
    @State private var arcReturnPercent: String = ""

    @State private var requiredPoints: String = ""
    @State private var locked: Bool = false
    @State private var pointsToWin: String = ""
    @State private var totalPointsToWin: Int = 0

    var body: some View {
        Form{
            Section(header: Text(NSLocalizedString("CURRENT_STATUS", comment: "Current status"))){
                VStack{
                    HStack{
                        Text(NSLocalizedString("LEVEL_POINTS", comment: "Level points"))
                            .layoutPriority(1)
                        Spacer()
                        TextField("0", text: $levelPoints)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    Text(NSLocalizedString("LEVEL_POINTS_SUBHEADLINE", comment: "Total building points for this level"))
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }

                VStack{
                    HStack{
                        Text(NSLocalizedString("TOTAL_BUILDING_POINTS", comment: "Total building points"))
                            .layoutPriority(1)
                        Spacer()
                        TextField("0", text: $totalBuildingPoints)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    Text(NSLocalizedString("TOTAL_BUILDING_POINTS_SUBHEADLINE", comment: "Total building points now"))
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }

                VStack{
                    HStack{
                        Text(NSLocalizedString("CURRENT_POSITION_POINTS", comment: "Current position points"))
                            .layoutPriority(1)
                        Spacer()
                        TextField("0", text: $currentPositionPoints)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    Text(NSLocalizedString("CURRENT_POSITION_POINTS_SUBHEADLINE", comment: "Total points for this position now"))
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }

                VStack{
                    HStack{
                        Text(NSLocalizedString("POSITION_RETURN_POINTS", comment: "Position return points"))
                            .layoutPriority(1)
                        Spacer()
                        TextField("0", text: $positionReturnPoints)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    Text(NSLocalizedString("POSITION_RETURN_POINTS_SUBHEADLINE", comment: "Points that return the position"))
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }

                VStack{
                    HStack{
                        Text(NSLocalizedString("ARC_PRC_RETURN", comment: "Arc return percent"))
                            .layoutPriority(1)
                        Spacer()
                        TextField("0", text: $arcReturnPercent)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    Text(NSLocalizedString("ARC_PRC_RETURN_SUBHEADLINE", comment: "Percent return for the Arc"))
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }
            }
            Button(NSLocalizedString("CALCULATE", comment: "Calculate"), action: {
                let xLevelPoints = (levelPoints as NSString).floatValue
                let xTotalBuildingPoints = (totalBuildingPoints as NSString).floatValue
                let xCurrentPositionPoints = (currentPositionPoints as NSString).floatValue
                let xPositionReturnPoints = (positionReturnPoints as NSString).floatValue
                let xArcReturnPercent = (arcReturnPercent as NSString).floatValue

                let xRequiredPoints = ((xCurrentPositionPoints + xLevelPoints - xTotalBuildingPoints) / 2).rounded()
                let xReturnPoints = (xPositionReturnPoints * (100 + xArcReturnPercent) / 100).rounded()

                debugPrint("xLevelPoints = \(xLevelPoints)")
                debugPrint("xTotalBuildingPoints = \(xTotalBuildingPoints)")
                debugPrint("xCurrentPositionPoints = \(xCurrentPositionPoints)")
                debugPrint("xPositionReturnPoints = \(xPositionReturnPoints)")
                debugPrint("xArcReturnPercent = \(xArcReturnPercent)")
                debugPrint("xRequiredPoints = \(xRequiredPoints)")
                debugPrint("xReturnPoints = \(xReturnPoints)")

                requiredPoints = String(Int(xRequiredPoints))
                totalPointsToWin = Int(xReturnPoints) - Int(xRequiredPoints)
                locked = (totalPointsToWin > 0) && (xRequiredPoints > xCurrentPositionPoints)
                pointsToWin = String(totalPointsToWin)
                if(!locked){
                    requiredPoints = ""
                    pointsToWin = ""
                }
            })
            .disabled(
                levelPoints.isEmpty || positionReturnPoints.isEmpty
            )
            Section(header: Text(NSLocalizedString("REQUIRES", comment: "Requires"))){
                HStack{
                    Text(NSLocalizedString("REQUIRED_POINTS", comment: "Required points"))
                    Spacer()
                    Text( requiredPoints)
                        .multilineTextAlignment(.trailing)
                }
                HStack{
                    Text(NSLocalizedString("STATUS", comment: "Status"))
                    Spacer()
                    if(locked){
                        Text(NSLocalizedString("LOCKED_MESSAGE", comment: "Locked"))
                            .foregroundColor(.green)
                            .multilineTextAlignment(.trailing)
                    } else {
                        Text(NSLocalizedString("UNLOCKED_MESSAGE", comment: "Unlocked"))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.trailing)
                    }
                }
                HStack{
                    Text(NSLocalizedString("POINTS_TO_WIN", comment: "Points to win"))
                    Spacer()
                    Text(pointsToWin)
                        .multilineTextAlignment(.trailing)
                }
            }
            Button(NSLocalizedString("CLEAR", comment: "Clear"), action: {
                levelPoints = ""
                totalBuildingPoints = ""
                currentPositionPoints = ""
                positionReturnPoints = ""
                arcReturnPercent = ""

                requiredPoints = ""
                locked = false
                pointsToWin = ""
                totalPointsToWin = 0
            })
        }
            
        .navigationTitle(NSLocalizedString("ATTACK_BUILDING", comment: "Attack building"))
        
        .onAppear(){
            arcReturnPercent = sharedData.arcReturn
        }
    }
}

struct AttackBuildingView_Previews: PreviewProvider {
    static var previews: some View {
        AttackBuildingView()
            .environmentObject(SharedData())
    }
}

//
//  ConditionScoreGaugeView.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/18/25.
//  Phase 1 - Month 1: Condition Score circular gauge component
//

import SwiftUI

struct ConditionScoreGaugeView: View {
    let conditionData: ConditionData
    let size: CGFloat

    @State private var animatedScore: Double = 0

    init(conditionData: ConditionData, size: CGFloat = 200) {
        self.conditionData = conditionData
        self.size = size
    }

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: size * 0.08)

            // Animated score arc
            Circle()
                .trim(from: 0, to: animatedScore / 100)
                .stroke(
                    scoreGradient,
                    style: StrokeStyle(
                        lineWidth: size * 0.08,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 1.0, dampingFraction: 0.7), value: animatedScore)

            // Center content
            VStack(spacing: size * 0.04) {
                // Score number
                Text("\(Int(animatedScore))")
                    .font(.system(size: size * 0.35, weight: .bold, design: .rounded))
                    .foregroundStyle(scoreColor)

                // "Condition Score" label
                Text("Condition Score")
                    .font(.system(size: size * 0.08, weight: .medium))
                    .foregroundColor(.secondary)

                // Alert level badge
                if conditionData.alertLevel != .none {
                    Text(conditionData.alertLevel.rawValue)
                        .font(.system(size: size * 0.07, weight: .bold))
                        .padding(.horizontal, size * 0.08)
                        .padding(.vertical, size * 0.03)
                        .background(alertBackgroundColor)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation {
                animatedScore = Double(conditionData.score)
            }
        }
        .onChange(of: conditionData.score) { oldValue, newValue in
            withAnimation {
                animatedScore = Double(newValue)
            }
        }
    }

    // MARK: - Computed Properties

    private var scoreGradient: AngularGradient {
        let colors = gradientColors(for: conditionData.score)
        return AngularGradient(
            colors: colors,
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360 * (Double(conditionData.score) / 100))
        )
    }

    private var scoreColor: Color {
        switch conditionData.score {
        case 80...100:
            return Color(red: 220/255, green: 38/255, blue: 38/255) // Red (Confirmed)
        case 70..<80:
            return Color(red: 245/255, green: 158/255, blue: 11/255) // Amber (Watch)
        case 50..<70:
            return Color(red: 16/255, green: 185/255, blue: 129/255) // Emerald (Favorable)
        case 30..<50:
            return Color(red: 59/255, green: 130/255, blue: 246/255) // Blue (Moderate)
        default:
            return Color(red: 107/255, green: 114/255, blue: 128/255) // Gray (Low)
        }
    }

    private var alertBackgroundColor: Color {
        switch conditionData.alertLevel {
        case .confirmed:
            return Color(red: 220/255, green: 38/255, blue: 38/255) // Red
        case .watch:
            return Color(red: 245/255, green: 158/255, blue: 11/255) // Amber
        case .none:
            return Color.clear
        }
    }

    private func gradientColors(for score: Int) -> [Color] {
        switch score {
        case 80...100:
            // Red gradient (Confirmed)
            return [
                Color(red: 239/255, green: 68/255, blue: 68/255),
                Color(red: 220/255, green: 38/255, blue: 38/255)
            ]
        case 70..<80:
            // Amber gradient (Watch)
            return [
                Color(red: 252/255, green: 211/255, blue: 77/255),
                Color(red: 245/255, green: 158/255, blue: 11/255)
            ]
        case 50..<70:
            // Emerald gradient (Favorable)
            return [
                Color(red: 52/255, green: 211/255, blue: 153/255),
                Color(red: 16/255, green: 185/255, blue: 129/255)
            ]
        case 30..<50:
            // Blue gradient (Moderate)
            return [
                Color(red: 96/255, green: 165/255, blue: 250/255),
                Color(red: 59/255, green: 130/255, blue: 246/255)
            ]
        default:
            // Gray gradient (Low)
            return [
                Color(red: 156/255, green: 163/255, blue: 175/255),
                Color(red: 107/255, green: 114/255, blue: 128/255)
            ]
        }
    }
}

// MARK: - Preview

#Preview("High Score") {
    ConditionScoreGaugeView(conditionData: .mockHighScore)
        .padding()
}

#Preview("Watch Alert") {
    ConditionScoreGaugeView(conditionData: .mockCurrent)
        .padding()
}

#Preview("Low Score") {
    ConditionScoreGaugeView(conditionData: .mockLowScore)
        .padding()
}

#Preview("Small Size") {
    ConditionScoreGaugeView(conditionData: .mockCurrent, size: 120)
        .padding()
}

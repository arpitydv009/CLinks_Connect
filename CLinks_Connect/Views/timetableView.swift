//
//  timetableView.swift
//  CLinks_Connect
//
//  Created by arpit on 09/10/26.
//

import SwiftUI

struct timetableView: View {
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.08, green: 0.09, blue: 0.15),
                        Color(red: 0.12, green: 0.13, blue: 0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                List {
                    ForEach(days, id: \.self) { day in
                        NavigationLink {
                            dayTimetableView(day: day)
                        } label: {
                            HStack {
                                Text(day)
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            .padding(23)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(red: 0.15, green: 0.16, blue: 0.22))
                            )
                        }
                        .listRowInsets(
                            EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16)
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            
        }
        .navigationTitle("Timetable")
            .navigationBarTitleDisplayMode(.inline)
    }}


struct timetableCard: View {
    let entry: timetableEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(entry.day)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.cyan)

            Text(entry.subject)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)

            HStack {
                Label(entry.time, systemImage: "clock")
                Spacer()
                Label(entry.room, systemImage: "location")
            }
            .font(.system(size: 13))
            .foregroundStyle(.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.16, blue: 0.22))
        )
    }
}
struct dayTimetableView: View {
    let day: String

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.08, green: 0.09, blue: 0.15),
                    Color(red: 0.12, green: 0.13, blue: 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            List {
                ForEach(dummyTimetable.filter { $0.day == day }) { entry in
                    timetableCard(entry: entry)
                        .listRowInsets(
                            EdgeInsets(
                                top: 6,
                                leading: 16,
                                bottom: 6,
                                trailing: 16
                            )
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(day)
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview{
    timetableView()
}

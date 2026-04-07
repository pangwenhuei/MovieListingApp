//
//  HomeView.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 06/04/2026.
//


import SwiftUI

struct HomeView: View {
    @State var viewModel = HomeViewModel()
    @State private var showFilters = false

    // Available years derived from fetched data
    var availableYears: [Int] {
        let years = viewModel.allYears
        return years.sorted(by: >)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                headerView

                if showFilters {
                    filterPanel
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        Text("Populars")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)

                        if viewModel.populars.isEmpty && !viewModel.isLoadingMore {
                            emptyStateView
                        } else {
                            ForEach(viewModel.populars) { movie in
                                HomeRowView(movie: movie)
                                    .foregroundColor(.primary)
                            }
                        }

                        // Footer
                        if viewModel.isLoadingMore {
                            HStack(spacing: 8) {
                                ProgressView()
                                Text("Loading more...")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        } else if viewModel.hasMorePages {
                            Color.clear
                                .frame(height: 1)
                                .onAppear {
                                    Task { await viewModel.loadMoreIfNeeded() }
                                }
                        } else if !viewModel.populars.isEmpty {
                            VStack(spacing: 4) {
                                Image(systemName: "checkmark.circle")
                                    .foregroundStyle(.secondary)
                                Text("You've reached the end")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    }
                    .padding()
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .animation(.easeInOut(duration: 0.25), value: showFilters)
            .task {
                await viewModel.loadMovies()
            }
        }
    }

    // MARK: - Header
    var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome back")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                Text("Pang")
                    .font(.title)
            }
            Spacer()
            //filled icon when any filter is active
            Button {
                showFilters.toggle()
            } label: {
                Image(systemName: viewModel.isFiltering ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    .font(.title2)
                    .foregroundStyle(viewModel.isFiltering ? .blue : .primary)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    // MARK: - Filter Panel - slides in/out with animation
    var filterPanel: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Title search
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search by title...", text: $viewModel.searchTitle)
                    .autocorrectionDisabled()
                if !viewModel.searchTitle.isEmpty {
                    Button {
                        viewModel.searchTitle = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(10)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))

            // Release year picker
            HStack {
                Text("Year")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Picker("Year", selection: $viewModel.selectedYear) {
                    Text("Any").tag(Optional<Int>.none)
                    ForEach(availableYears, id: \.self) { year in
                        Text(String(year)).tag(Optional(year))
                    }
                }
                .pickerStyle(.menu)
            }

            // Date range
            VStack(alignment: .leading, spacing: 6) {
                Text("Release date range")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    DatePickerField(
                        label: "From",
                        date: $viewModel.startDate,
                        maxDate: viewModel.endDate
                    )
                    DatePickerField(
                        label: "To",
                        date: $viewModel.endDate,
                        minDate: viewModel.startDate
                    )
                }
            }

            // Active filter chips + reset
            if viewModel.isFiltering {
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            if !viewModel.searchTitle.isEmpty {
                                FilterChip(label: "\"\(viewModel.searchTitle)\"") {
                                    viewModel.searchTitle = ""
                                }
                            }
                            if let year = viewModel.selectedYear {
                                FilterChip(label: "\(year)") {
                                    viewModel.selectedYear = nil
                                }
                            }
                            if viewModel.startDate != nil || viewModel.endDate != nil {
                                FilterChip(label: "Date range") {
                                    viewModel.startDate = nil
                                    viewModel.endDate = nil
                                }
                            }
                        }
                    }
                    Button("Reset all") {
                        viewModel.resetFilters()
                    }
                    .font(.caption)
                    .foregroundStyle(.red)
                }
            }
        }
        .padding()
        .background(.regularMaterial)
    }

    // MARK: - Empty state
    var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "film.slash")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("No movies found")
                .font(.headline)
            if viewModel.isFiltering {
                Text("Try adjusting your filters")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Button("Reset filters") {
                    viewModel.resetFilters()
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

// MARK: - Supporting Views

struct DatePickerField: View {
    let label: String
    @Binding var date: Date?
    var minDate: Date? = nil
    var maxDate: Date? = nil

    @State private var showPicker = false
    @State private var internalDate = Date()

    var body: some View {
        Button {
            internalDate = date ?? Date()
            showPicker = true
        } label: {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(date.map { formatted($0) } ?? "Any")
                    .font(.caption)
                    .foregroundStyle(date == nil ? .secondary : .primary)
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        }
        .sheet(isPresented: $showPicker) {
            VStack {
                DatePicker(
                    label,
                    selection: $internalDate,
                    in: dateRange,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()

                HStack {
                    if date != nil {
                        Button("Clear") {
                            date = nil
                            showPicker = false
                        }
                        .foregroundStyle(.red)
                    }
                    Spacer()
                    Button("Done") {
                        date = internalDate
                        showPicker = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .presentationDetents([.medium])
        }
    }

    private var dateRange: ClosedRange<Date> {
        let min = minDate ?? Date.distantPast
        let max = maxDate ?? Date.distantFuture
        return min <= max ? min...max : Date.distantPast...Date.distantFuture
    }

    private func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}

struct FilterChip: View {
    let label: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.caption)
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption2)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(.blue.opacity(0.15), in: Capsule())
        .foregroundStyle(.blue)
    }
}

#Preview {
    HomeView().preferredColorScheme(.dark)
}

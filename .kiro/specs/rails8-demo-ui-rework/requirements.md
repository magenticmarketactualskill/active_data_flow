# Requirements Document

## Introduction

This document outlines the requirements for reworking the user interface of the Rails 8 Demo application. The current implementation uses inline styles scattered across view templates, making maintenance difficult and creating inconsistent styling. The rework will modernize the UI with a component-based approach using Tailwind CSS (already configured in Rails 8), improve accessibility, enhance responsiveness, and create a more maintainable codebase.

## Glossary

- **Rails8DemoApp**: The Rails 8 demonstration application showcasing ActiveDataFlow functionality
- **ViewTemplate**: ERB files that render HTML content in the Rails application
- **TailwindCSS**: A utility-first CSS framework for styling web interfaces
- **ComponentPattern**: A reusable UI element with consistent styling and behavior
- **ResponsiveDesign**: UI that adapts to different screen sizes and devices
- **AccessibilityCompliance**: Adherence to WCAG 2.1 AA standards for web accessibility
- **InlineStyle**: CSS styles embedded directly in HTML elements via style attributes

## Requirements

### Requirement 1: Remove Inline Styles

**User Story:** As a developer, I want all inline styles removed from view templates, so that the codebase is easier to maintain and styling is consistent.

#### Acceptance Criteria

1. WHEN a developer inspects any ViewTemplate, THE Rails8DemoApp SHALL contain zero InlineStyle tags
2. WHEN a developer reviews the home index view, THE Rails8DemoApp SHALL use TailwindCSS utility classes instead of style attributes
3. WHEN a developer reviews the products index view, THE Rails8DemoApp SHALL use TailwindCSS utility classes instead of style attributes
4. WHEN a developer reviews the product exports index view, THE Rails8DemoApp SHALL use TailwindCSS utility classes instead of style attributes

### Requirement 2: Implement Consistent Layout

**User Story:** As a user, I want a consistent navigation and layout across all pages, so that I can easily navigate the application.

#### Acceptance Criteria

1. THE Rails8DemoApp SHALL display a navigation header on every page with links to Products, Exports, and DataFlows
2. THE Rails8DemoApp SHALL display a footer on every page with application information
3. WHEN a user views any page, THE Rails8DemoApp SHALL highlight the current page in the navigation menu
4. THE Rails8DemoApp SHALL maintain consistent spacing and typography across all pages

### Requirement 3: Enhance Dashboard Statistics Display

**User Story:** As a user, I want to see application statistics in an organized and visually appealing way, so that I can quickly understand the system status.

#### Acceptance Criteria

1. WHEN a user views the home page, THE Rails8DemoApp SHALL display product count in a card component
2. WHEN a user views the home page, THE Rails8DemoApp SHALL display export count in a card component
3. WHEN a user views the home page, THE Rails8DemoApp SHALL display active DataFlow count in a card component
4. THE Rails8DemoApp SHALL arrange statistics cards in a responsive grid layout
5. THE Rails8DemoApp SHALL use distinct colors for each statistic type

### Requirement 4: Improve Data Table Presentation

**User Story:** As a user, I want product and export data displayed in clean, readable tables, so that I can easily scan and understand the information.

#### Acceptance Criteria

1. WHEN a user views the products page, THE Rails8DemoApp SHALL display products in a table with alternating row colors
2. WHEN a user views the product exports page, THE Rails8DemoApp SHALL display exports in a table with alternating row colors
3. THE Rails8DemoApp SHALL display table headers with clear visual distinction from data rows
4. WHEN a user hovers over a table row, THE Rails8DemoApp SHALL highlight the row
5. THE Rails8DemoApp SHALL make tables horizontally scrollable on mobile devices

### Requirement 5: Create Reusable Button Components

**User Story:** As a developer, I want consistent button styling throughout the application, so that the interface looks professional and cohesive.

#### Acceptance Criteria

1. THE Rails8DemoApp SHALL define primary button styles using TailwindCSS classes
2. THE Rails8DemoApp SHALL define secondary button styles using TailwindCSS classes
3. THE Rails8DemoApp SHALL define danger button styles using TailwindCSS classes
4. WHEN a user hovers over any button, THE Rails8DemoApp SHALL display a visual hover effect
5. THE Rails8DemoApp SHALL apply consistent button styles to all action buttons

### Requirement 6: Implement Responsive Design

**User Story:** As a mobile user, I want the application to work well on my device, so that I can access it from anywhere.

#### Acceptance Criteria

1. WHEN a user views the application on a mobile device, THE Rails8DemoApp SHALL display navigation in a mobile-friendly format
2. WHEN a user views statistics cards on a mobile device, THE Rails8DemoApp SHALL stack cards vertically
3. WHEN a user views tables on a mobile device, THE Rails8DemoApp SHALL enable horizontal scrolling
4. THE Rails8DemoApp SHALL use responsive breakpoints for screen sizes below 768px
5. THE Rails8DemoApp SHALL maintain readable font sizes on all device sizes

### Requirement 7: Enhance DataFlow Visualization

**User Story:** As a user, I want to understand the data flow process visually, so that I can see how data moves through the system.

#### Acceptance Criteria

1. WHEN a user views the home page, THE Rails8DemoApp SHALL display a visual diagram showing Source, Transform, and Sink stages
2. THE Rails8DemoApp SHALL use distinct colors for each stage in the data flow diagram
3. THE Rails8DemoApp SHALL display arrows or connectors between flow stages
4. WHEN a user views the home page on mobile, THE Rails8DemoApp SHALL stack flow diagram elements vertically
5. THE Rails8DemoApp SHALL display transformation details in an organized list format

### Requirement 8: Improve Code Block Presentation

**User Story:** As a developer viewing the demo, I want code examples to be clearly formatted and readable, so that I can understand the implementation.

#### Acceptance Criteria

1. WHEN a user views code examples, THE Rails8DemoApp SHALL display code in a monospace font
2. THE Rails8DemoApp SHALL use syntax-appropriate colors for code display
3. THE Rails8DemoApp SHALL provide horizontal scrolling for long code lines
4. THE Rails8DemoApp SHALL display code blocks with a dark background theme
5. THE Rails8DemoApp SHALL maintain proper indentation in code examples

### Requirement 9: Add Loading and Empty States

**User Story:** As a user, I want clear feedback when data is loading or unavailable, so that I understand the application state.

#### Acceptance Criteria

1. WHEN no product exports exist, THE Rails8DemoApp SHALL display an empty state message with guidance
2. WHEN no products exist, THE Rails8DemoApp SHALL display an empty state message
3. THE Rails8DemoApp SHALL center empty state messages in the content area
4. THE Rails8DemoApp SHALL include actionable suggestions in empty state messages
5. THE Rails8DemoApp SHALL style empty states consistently with the overall design

### Requirement 10: Ensure Accessibility Compliance

**User Story:** As a user with accessibility needs, I want the application to be usable with assistive technologies, so that I can access all features.

#### Acceptance Criteria

1. THE Rails8DemoApp SHALL provide alt text for all icon elements
2. THE Rails8DemoApp SHALL maintain color contrast ratios of at least 4.5:1 for normal text
3. THE Rails8DemoApp SHALL maintain color contrast ratios of at least 3:1 for large text
4. THE Rails8DemoApp SHALL support keyboard navigation for all interactive elements
5. WHEN a user focuses on an interactive element, THE Rails8DemoApp SHALL display a visible focus indicator

### Requirement 11: Redesign DataFlow List View

**User Story:** As a user, I want to view all data flows in a clean, organized list, so that I can quickly understand their status and configuration.

#### Acceptance Criteria

1. WHEN a user views the data flows page, THE Rails8DemoApp SHALL display each data flow in a card component
2. THE Rails8DemoApp SHALL display data flow name, status, source, sink, and last run information for each flow
3. THE Rails8DemoApp SHALL use TailwindCSS classes instead of InlineStyle tags
4. WHEN a user views the data flows page, THE Rails8DemoApp SHALL provide action buttons for viewing details, viewing runs, and toggling status
5. WHEN no data flows exist, THE Rails8DemoApp SHALL display an empty state message

### Requirement 12: Redesign DataFlow Details View

**User Story:** As a user, I want to view detailed information about a specific data flow, so that I can understand its configuration and recent activity.

#### Acceptance Criteria

1. WHEN a user views a data flow details page, THE Rails8DemoApp SHALL display all data flow properties in a structured layout
2. THE Rails8DemoApp SHALL display source, sink, and runtime configurations in formatted code blocks
3. THE Rails8DemoApp SHALL display recent runs in a table with status indicators
4. THE Rails8DemoApp SHALL use TailwindCSS classes instead of InlineStyle tags
5. THE Rails8DemoApp SHALL provide action buttons for editing, toggling status, and deleting the data flow

### Requirement 13: Redesign DataFlow Edit Form

**User Story:** As a user, I want to edit data flow properties through a clean form interface, so that I can update configurations easily.

#### Acceptance Criteria

1. WHEN a user views the data flow edit page, THE Rails8DemoApp SHALL display a form with name and status fields
2. THE Rails8DemoApp SHALL display validation errors in a clearly formatted error message component
3. THE Rails8DemoApp SHALL use TailwindCSS classes for form inputs and labels
4. THE Rails8DemoApp SHALL provide submit and cancel buttons with consistent styling
5. THE Rails8DemoApp SHALL use TailwindCSS classes instead of InlineStyle tags

### Requirement 14: Redesign DataFlowRuns List View

**User Story:** As a user, I want to view all execution runs for a data flow, so that I can monitor performance and troubleshoot issues.

#### Acceptance Criteria

1. WHEN a user views the data flow runs page, THE Rails8DemoApp SHALL display runs in a table with ID, status, timing, and duration columns
2. THE Rails8DemoApp SHALL display status badges with color-coded indicators for success, failed, in_progress, and pending states
3. WHEN a run has an error message, THE Rails8DemoApp SHALL display the error in an expandable row below the run
4. THE Rails8DemoApp SHALL use TailwindCSS classes instead of InlineStyle tags
5. THE Rails8DemoApp SHALL provide a purge action to delete all runs for the data flow

# Implementation Plan

- [x] 1. Install and configure Tailwind CSS
  - Install tailwindcss-rails gem
  - Run rails tailwindcss:install command
  - Configure tailwind.config.js with correct content paths
  - Verify Tailwind is working by checking compiled CSS
  - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [x] 2. Create application helper methods for reusable components
- [x] 2.1 Add button_classes helper method
  - Create button_classes method in ApplicationHelper
  - Support :primary, :secondary, :danger, and :success variants
  - Include all Tailwind classes for buttons with hover and focus states
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 10.5_

- [x] 2.2 Add status_badge helper method
  - Create status_badge helper method for active/inactive states
  - Support different status types (active, inactive, success, failed, pending, in_progress)
  - Return appropriate Tailwind classes for each status
  - _Requirements: 4.1, 4.2, 11.2, 14.2_

- [x] 3. Refactor home index view
- [x] 3.1 Remove inline styles from home/index.html.erb
  - Delete all <style> tags from the view
  - Remove all style attributes from HTML elements
  - _Requirements: 1.1, 1.2_

- [x] 3.2 Implement statistics cards with Tailwind
  - Create responsive grid layout for statistics cards
  - Style product count card with blue color scheme
  - Style export count card with green color scheme
  - Style DataFlow count card with purple color scheme
  - Add responsive breakpoints for mobile stacking
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 6.2_

- [x] 3.3 Implement DataFlow visualization diagram
  - Create horizontal flow diagram with Source, Transform, and Sink boxes
  - Style each stage with distinct colors (blue, purple, green)
  - Add arrows between stages
  - Make diagram stack vertically on mobile devices
  - _Requirements: 7.1, 7.2, 7.3, 7.4_

- [x] 3.4 Implement transformation details section
  - Display transformation details in organized list format
  - Style with appropriate spacing and typography
  - _Requirements: 7.5_

- [x] 3.5 Implement code block component
  - Style code block with dark background theme
  - Use monospace font for code
  - Enable horizontal scrolling for long lines
  - Add proper syntax highlighting colors
  - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5_

- [x] 3.6 Implement quick actions section
  - Style action buttons using button_classes helper
  - Ensure proper spacing and alignment
  - _Requirements: 5.5_

- [x] 4. Refactor products index view
- [x] 4.1 Remove inline styles from products/index.html.erb
  - Delete all <style> tags from the view
  - Remove all style attributes from HTML elements
  - _Requirements: 1.1, 1.3_

- [x] 4.2 Implement products table with Tailwind
  - Create responsive table wrapper with horizontal scroll
  - Style table headers with gray background
  - Add hover effects to table rows
  - Style active/inactive badges using status_badge helper
  - _Requirements: 4.1, 4.3, 4.4, 4.5, 6.3_

- [x] 4.3 Add navigation breadcrumbs
  - Style navigation links consistently
  - Ensure proper spacing and hover effects
  - _Requirements: 2.1, 2.3_

- [x] 5. Refactor product exports index view
- [x] 5.1 Remove inline styles from product_exports/index.html.erb
  - Delete all <style> tags from the view
  - Remove all style attributes from HTML elements
  - _Requirements: 1.1, 1.4_

- [x] 5.2 Implement product exports table with Tailwind
  - Create responsive table wrapper with horizontal scroll
  - Style table headers with gray background
  - Add hover effects to table rows
  - _Requirements: 4.2, 4.3, 4.4, 4.5, 6.3_

- [x] 5.3 Implement empty state component
  - Create centered empty state message
  - Add icon and descriptive text
  - Include actionable button using button_classes helper
  - _Requirements: 9.1, 9.3, 9.4, 9.5_

- [x] 5.4 Add navigation breadcrumbs
  - Style navigation links consistently
  - Ensure proper spacing and hover effects
  - _Requirements: 2.1, 2.3_

- [x] 6. Refactor DataFlows index view
- [x] 6.1 Remove inline styles from active_data_flow/data_flows/index.html.erb
  - Delete all <style> tags from the view
  - Remove all style attributes from HTML elements
  - _Requirements: 1.1, 11.3_

- [x] 6.2 Implement DataFlow list cards
  - Create card component for each data flow
  - Display name, status, source, sink, and last run information
  - Add left border accent in purple
  - Style status badges using status_badge helper
  - _Requirements: 11.1, 11.2_

- [x] 6.3 Implement DataFlow action buttons
  - Add View Details, View Runs, and Toggle Status buttons
  - Use button_classes helper for consistent styling
  - _Requirements: 11.4_

- [x] 6.4 Implement empty state for no data flows
  - Create centered empty state message
  - Add descriptive text about data flow definitions
  - _Requirements: 11.5, 9.2, 9.3, 9.4, 9.5_

- [x] 7. Refactor DataFlow show view
- [x] 7.1 Remove inline styles from active_data_flow/data_flows/show.html.erb
  - Delete all <style> tags from the view
  - Remove all style attributes from HTML elements
  - _Requirements: 1.1, 12.4_

- [x] 7.2 Implement DataFlow information card
  - Create structured layout for data flow properties
  - Use definition list (dl/dt/dd) for key-value pairs
  - Style status badge using status_badge helper
  - Display run statistics with color-coded counts
  - _Requirements: 12.1_

- [x] 7.3 Implement recent runs table
  - Create compact table showing last 5 runs
  - Style status badges with appropriate colors
  - Display timing and duration information
  - Add "View All Runs" link
  - _Requirements: 12.3_

- [x] 7.4 Implement configuration code blocks
  - Create separate cards for source, sink, and runtime configs
  - Style with dark background and monospace font
  - Enable horizontal scrolling
  - Format JSON with proper indentation
  - _Requirements: 12.2, 8.1, 8.3, 8.4, 8.5_

- [x] 7.5 Implement action buttons
  - Add Edit, Toggle Status, and Delete buttons
  - Use button_classes helper for consistent styling
  - Add confirmation dialog for delete action
  - _Requirements: 12.5_

- [x] 8. Refactor DataFlow edit view
- [x] 8.1 Remove inline styles from active_data_flow/data_flows/edit.html.erb
  - Delete all <style> tags from the view
  - Remove all style attributes from HTML elements
  - _Requirements: 1.1, 13.5_

- [x] 8.2 Implement form with Tailwind styling
  - Style form inputs with border and focus states
  - Style labels with appropriate typography
  - Add proper spacing between form fields
  - _Requirements: 13.1, 13.3_

- [x] 8.3 Implement error messages component
  - Create error alert with red color scheme
  - Display error count and list of messages
  - Add error icon for visual clarity
  - _Requirements: 13.2_

- [x] 8.4 Implement form action buttons
  - Add Submit and Cancel buttons
  - Use button_classes helper for styling
  - _Requirements: 13.4_

- [x] 9. Refactor DataFlowRuns index view
- [x] 9.1 Remove inline styles from active_data_flow/data_flow_runs/index.html.erb
  - Delete all <style> tags from the view
  - Remove all style attributes from HTML elements
  - _Requirements: 1.1, 14.4_

- [x] 9.2 Implement DataFlowRuns table
  - Create responsive table with all required columns
  - Style table headers with gray background
  - Add hover effects to table rows
  - Enable horizontal scrolling on mobile
  - _Requirements: 14.1, 6.3_

- [x] 9.3 Implement status badges for runs
  - Use status_badge helper for run statuses
  - Support success, failed, in_progress, and pending states
  - Apply appropriate color schemes for each state
  - _Requirements: 14.2_

- [x] 9.4 Implement error message display
  - Show error messages in expandable rows below failed runs
  - Style with red background and formatted pre block
  - Enable horizontal scrolling for long error messages
  - _Requirements: 14.3_

- [x] 9.5 Add purge action button
  - Add Purge All Runs button with confirmation
  - Style as danger action
  - _Requirements: 14.5_

- [x] 10. Verify layout consistency
- [x] 10.1 Ensure navigation header is consistent
  - Verify header appears on all pages
  - Check active link highlighting works correctly
  - Test Trigger Heartbeat button functionality
  - _Requirements: 2.1, 2.3_

- [x] 10.2 Ensure footer is consistent
  - Verify footer appears on all pages
  - Check footer links and copyright information
  - _Requirements: 2.2_

- [x] 10.3 Verify flash messages styling
  - Check flash messages display correctly
  - Ensure proper color coding for notice vs alert
  - _Requirements: 2.4_

- [x] 11. Test responsive design
- [x] 11.1 Test mobile layout (320px - 767px)
  - Verify statistics cards stack vertically
  - Check tables scroll horizontally
  - Verify navigation is mobile-friendly
  - Test DataFlow diagram stacks vertically
  - _Requirements: 6.1, 6.2, 6.3, 6.4, 7.4_

- [x] 11.2 Test tablet layout (768px - 1023px)
  - Verify grid layouts adapt appropriately
  - Check navigation spacing
  - _Requirements: 6.4_

- [x] 11.3 Test desktop layout (1024px+)
  - Verify all components display correctly
  - Check maximum width constraints
  - _Requirements: 6.5_

- [x] 12. Verify accessibility compliance
- [x] 12.1 Check color contrast ratios
  - Verify all text meets 4.5:1 contrast for normal text
  - Verify large text meets 3:1 contrast
  - Test with WebAIM Contrast Checker
  - _Requirements: 10.2, 10.3_

- [x] 12.2 Test keyboard navigation
  - Tab through all interactive elements
  - Verify focus indicators are visible
  - Check logical tab order
  - _Requirements: 10.4, 10.5_

- [x] 12.3 Add ARIA labels where needed
  - Add aria-label to icon-only buttons
  - Ensure semantic HTML structure
  - _Requirements: 10.1_

- [x] 13. Final verification and cleanup
- [x] 13.1 Verify all inline styles are removed
  - Search for <style> tags in all view files
  - Search for style="" attributes in all view files
  - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [x] 13.2 Test all user flows
  - Navigate through all pages
  - Click all buttons and links
  - Verify data displays correctly
  - Test form submissions
  - _Requirements: 2.1, 2.2, 2.3, 2.4_

- [x] 13.3 Cross-browser testing
  - Test in Chrome
  - Test in Firefox
  - Test in Safari
  - Test in Edge
  - _Requirements: 6.5_

# Design Document: Rails 8 Demo UI Rework

## Overview

This design document outlines the approach for modernizing the Rails 8 Demo application's user interface. The current implementation uses inline `<style>` tags within ERB templates, which creates maintenance challenges and inconsistent styling. The redesign will leverage Tailwind CSS utility classes to create a clean, maintainable, and accessible interface while preserving all existing functionality.

### Design Goals

1. **Eliminate inline styles** - Remove all `<style>` tags and style attributes from view templates
2. **Establish design system** - Create consistent spacing, typography, and color schemes
3. **Improve maintainability** - Use utility-first CSS approach with Tailwind
4. **Enhance accessibility** - Ensure WCAG 2.1 AA compliance
5. **Optimize responsiveness** - Provide excellent experience across all device sizes
6. **Preserve functionality** - Maintain all existing features and user flows

## Architecture

### Technology Stack

- **CSS Framework**: Tailwind CSS (to be installed)
- **View Layer**: ERB templates
- **Asset Pipeline**: Propshaft (Rails 8 default)
- **JavaScript**: Stimulus (for interactive components if needed)

### File Structure

```
submodules/examples/rails8-demo/
├── app/
│   ├── assets/
│   │   └── stylesheets/
│   │       └── application.tailwind.css  # Tailwind entry point
│   ├── views/
│   │   ├── layouts/
│   │   │   └── application.html.erb      # Updated layout
│   │   ├── home/
│   │   │   └── index.html.erb            # Redesigned dashboard
│   │   ├── products/
│   │   │   └── index.html.erb            # Redesigned products list
│   │   ├── product_exports/
│   │   │   └── index.html.erb            # Redesigned exports list
│   │   └── active_data_flow/
│   │       ├── data_flows/
│   │       │   ├── index.html.erb        # DataFlows list
│   │       │   ├── show.html.erb         # DataFlow details
│   │       │   └── edit.html.erb         # DataFlow edit form
│   │       └── data_flow_runs/
│   │           └── index.html.erb        # DataFlowRuns list
│   └── helpers/
│       └── application_helper.rb         # Button and component helpers
├── config/
│   └── tailwind.config.js                # Tailwind configuration
└── package.json                          # Node dependencies
```

## Components and Interfaces

### 1. Layout Component (application.html.erb)

The application layout already has Tailwind classes in place. We'll enhance it to ensure consistency.

**Key Elements:**
- **Header Navigation**: Sticky header with logo, nav links, and action button
- **Main Content Area**: Flexible container with consistent padding
- **Footer**: Application information and links
- **Flash Messages**: Styled notification system

**Tailwind Classes:**
- Container: `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8`
- Header: `bg-white shadow-sm sticky top-0 z-50`
- Navigation: `flex items-center gap-6`
- Active link: `text-indigo-600`

### 2. Statistics Card Component

Displays key metrics on the dashboard.

**Structure:**
```erb
<div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
  <div class="bg-white rounded-lg shadow-sm p-6 border border-gray-200">
    <div class="text-4xl font-bold text-blue-600 mb-2">
      <%= @product_count %>
    </div>
    <div class="text-gray-600 font-medium">Total Products</div>
    <div class="text-sm text-gray-500 mt-1">
      (<%= @active_product_count %> active)
    </div>
  </div>
  <!-- Additional cards -->
</div>
```

**Color Scheme:**
- Products: `text-blue-600` (blue-600: #2563eb)
- Exports: `text-green-600` (green-600: #16a34a)
- DataFlows: `text-purple-600` (purple-600: #9333ea)

### 3. Data Table Component

Displays products and exports in a structured format.

**Structure:**
```erb
<div class="bg-white rounded-lg shadow-sm overflow-hidden">
  <div class="overflow-x-auto">
    <table class="min-w-full divide-y divide-gray-200">
      <thead class="bg-gray-50">
        <tr>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Column Name
          </th>
        </tr>
      </thead>
      <tbody class="bg-white divide-y divide-gray-200">
        <tr class="hover:bg-gray-50 transition-colors">
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
            Data
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</div>
```

**Features:**
- Horizontal scroll on mobile: `overflow-x-auto`
- Hover effect: `hover:bg-gray-50 transition-colors`
- Alternating rows: Handled by `divide-y divide-gray-200`

### 4. Button Component System

Consistent button styling across the application.

**Button Variants:**

1. **Primary Button** (main actions):
   ```
   bg-indigo-600 text-white px-4 py-2 rounded-lg font-medium
   hover:bg-indigo-700 transition-colors shadow-sm hover:shadow
   focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2
   ```

2. **Secondary Button** (alternative actions):
   ```
   bg-white text-gray-700 px-4 py-2 rounded-lg font-medium border border-gray-300
   hover:bg-gray-50 transition-colors
   focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2
   ```

3. **Danger Button** (destructive actions):
   ```
   bg-red-600 text-white px-4 py-2 rounded-lg font-medium
   hover:bg-red-700 transition-colors shadow-sm hover:shadow
   focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2
   ```

4. **Success Button** (positive actions):
   ```
   bg-green-600 text-white px-4 py-2 rounded-lg font-medium
   hover:bg-green-700 transition-colors shadow-sm hover:shadow
   focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2
   ```

**Helper Method:**
```ruby
def button_classes(variant = :primary)
  base = "inline-flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition-colors shadow-sm hover:shadow focus:outline-none focus:ring-2 focus:ring-offset-2"
  
  case variant
  when :primary
    "#{base} bg-indigo-600 text-white hover:bg-indigo-700 focus:ring-indigo-500"
  when :secondary
    "#{base} bg-white text-gray-700 border border-gray-300 hover:bg-gray-50 focus:ring-indigo-500"
  when :danger
    "#{base} bg-red-600 text-white hover:bg-red-700 focus:ring-red-500"
  when :success
    "#{base} bg-green-600 text-white hover:bg-green-700 focus:ring-green-500"
  end
end
```

### 5. DataFlow Visualization Component

Visual representation of the data pipeline.

**Structure:**
```erb
<div class="bg-gradient-to-r from-blue-50 to-purple-50 rounded-lg p-8">
  <div class="flex flex-col md:flex-row items-center justify-center gap-4 md:gap-8">
    <!-- Source Box -->
    <div class="bg-blue-600 text-white rounded-lg p-6 text-center min-w-[200px] shadow-lg">
      <div class="text-lg font-bold mb-2">Source</div>
      <div class="text-sm opacity-90">Products Table</div>
      <div class="text-xs opacity-75 mt-2">Active products only</div>
    </div>
    
    <!-- Arrow -->
    <div class="text-gray-400 text-3xl transform md:transform-none rotate-90 md:rotate-0">
      →
    </div>
    
    <!-- Transform Box -->
    <div class="bg-purple-600 text-white rounded-lg p-6 text-center min-w-[200px] shadow-lg">
      <div class="text-lg font-bold mb-2">Transform</div>
      <div class="text-sm opacity-90">Data Processing</div>
      <div class="text-xs opacity-75 mt-2">Price, category, timestamp</div>
    </div>
    
    <!-- Arrow -->
    <div class="text-gray-400 text-3xl transform md:transform-none rotate-90 md:rotate-0">
      →
    </div>
    
    <!-- Sink Box -->
    <div class="bg-green-600 text-white rounded-lg p-6 text-center min-w-[200px] shadow-lg">
      <div class="text-lg font-bold mb-2">Sink</div>
      <div class="text-sm opacity-90">Product Exports</div>
      <div class="text-xs opacity-75 mt-2">Transformed records</div>
    </div>
  </div>
</div>
```

**Responsive Behavior:**
- Desktop: Horizontal flow with right arrows
- Mobile: Vertical stack with down arrows (using `rotate-90 md:rotate-0`)

### 6. Code Block Component

Displays code examples with syntax highlighting.

**Structure:**
```erb
<div class="bg-gray-900 rounded-lg overflow-hidden">
  <div class="px-6 py-4 bg-gray-800 border-b border-gray-700">
    <span class="text-gray-400 text-sm font-mono">ProductSyncFlow</span>
  </div>
  <div class="p-6 overflow-x-auto">
    <pre class="text-sm text-gray-100 font-mono leading-relaxed"><code><%= code_content %></code></pre>
  </div>
</div>
```

**Features:**
- Dark theme: `bg-gray-900 text-gray-100`
- Horizontal scroll: `overflow-x-auto`
- Monospace font: `font-mono`
- Header bar: `bg-gray-800 border-b border-gray-700`

### 7. Empty State Component

Displays when no data is available.

**Structure:**
```erb
<div class="bg-white rounded-lg shadow-sm p-12 text-center">
  <div class="text-gray-400 text-6xl mb-4">📦</div>
  <h3 class="text-xl font-semibold text-gray-900 mb-2">No exports yet</h3>
  <p class="text-gray-600 mb-6">
    Trigger the DataFlow to sync products.
  </p>
  <%= link_to "Trigger Heartbeat", heartbeat_click_path, 
      class: button_classes(:primary) %>
</div>
```

### 8. Badge Component

Status indicators for products and other entities.

**Variants:**
```erb
<!-- Active Badge -->
<span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
  Active
</span>

<!-- Inactive Badge -->
<span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-800">
  Inactive
</span>
```

### 9. Alert/Warning Component

Displays important messages to users.

**Structure:**
```erb
<div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 rounded-r-lg">
  <div class="flex">
    <div class="flex-shrink-0">
      <svg class="h-5 w-5 text-yellow-400" viewBox="0 0 20 20" fill="currentColor">
        <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
      </svg>
    </div>
    <div class="ml-3">
      <p class="text-sm text-yellow-700">
        <strong class="font-medium">Development Status:</strong>
        The ActiveDataFlow gems are currently being implemented.
      </p>
    </div>
  </div>
</div>
```

### 10. DataFlow List Item Component

Displays individual data flow information in the index view.

**Structure:**
```erb
<div class="bg-white rounded-lg shadow-sm border-l-4 border-purple-600 p-6 hover:shadow-md transition-shadow">
  <div class="flex justify-between items-start mb-4">
    <h3 class="text-xl font-semibold text-gray-900"><%= data_flow.name %></h3>
    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium 
                 <%= data_flow.status == 'active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800' %>">
      <%= data_flow.status.upcase %>
    </span>
  </div>
  
  <div class="space-y-2 text-sm text-gray-600 mb-4">
    <p><span class="font-medium text-gray-900">Source:</span> <%= data_flow.source['model_class'] %></p>
    <p><span class="font-medium text-gray-900">Sink:</span> <%= data_flow.sink['model_class'] %></p>
    <p><span class="font-medium text-gray-900">Batch Size:</span> <%= data_flow.source['batch_size'] || 100 %></p>
    <% if data_flow.last_run_at %>
      <p><span class="font-medium text-gray-900">Last Run:</span> <%= data_flow.last_run_at.strftime("%Y-%m-%d %H:%M:%S") %></p>
    <% end %>
  </div>
  
  <div class="flex gap-2">
    <%= link_to "View Details", data_flow_path(data_flow), class: button_classes(:primary) %>
    <%= link_to "View Runs", data_flow_runs_path(data_flow), class: button_classes(:secondary) %>
    <%= button_to data_flow.status == 'active' ? 'Deactivate' : 'Activate', 
                  toggle_status_path(data_flow), 
                  method: :patch, 
                  class: button_classes(:secondary) %>
  </div>
</div>
```

### 11. DataFlow Details Component

Displays detailed information about a specific data flow.

**Structure:**
```erb
<div class="space-y-6">
  <!-- Status Card -->
  <div class="bg-white rounded-lg shadow-sm p-6">
    <h2 class="text-2xl font-bold text-gray-900 mb-6">Data Flow Information</h2>
    <dl class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <dt class="text-sm font-medium text-gray-500">Name</dt>
        <dd class="mt-1 text-sm text-gray-900"><%= @data_flow.name %></dd>
      </div>
      <div>
        <dt class="text-sm font-medium text-gray-500">Status</dt>
        <dd class="mt-1">
          <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium 
                       <%= @data_flow.status == 'active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800' %>">
            <%= @data_flow.status.upcase %>
          </span>
        </dd>
      </div>
      <!-- Additional fields -->
    </dl>
  </div>
  
  <!-- Configuration Cards -->
  <div class="bg-white rounded-lg shadow-sm p-6">
    <h3 class="text-lg font-semibold text-gray-900 mb-4">Source Configuration</h3>
    <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono"><%= JSON.pretty_generate(@data_flow.source) %></pre>
  </div>
</div>
```

### 12. DataFlow Runs Table Component

Displays a list of data flow execution runs.

**Structure:**
```erb
<div class="bg-white rounded-lg shadow-sm overflow-hidden">
  <div class="overflow-x-auto">
    <table class="min-w-full divide-y divide-gray-200">
      <thead class="bg-gray-50">
        <tr>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Run After</th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Started</th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Duration</th>
        </tr>
      </thead>
      <tbody class="bg-white divide-y divide-gray-200">
        <% @data_flow_runs.each do |run| %>
          <tr class="hover:bg-gray-50 transition-colors">
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><%= run.id %></td>
            <td class="px-6 py-4 whitespace-nowrap">
              <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium
                           <%= case run.status
                               when 'success' then 'bg-green-100 text-green-800'
                               when 'failed' then 'bg-red-100 text-red-800'
                               when 'in_progress' then 'bg-blue-100 text-blue-800'
                               when 'pending' then 'bg-yellow-100 text-yellow-800'
                               else 'bg-gray-100 text-gray-800'
                               end %>">
                <%= run.status.upcase %>
              </span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
              <%= run.run_after.strftime('%m/%d %H:%M') %>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
              <%= run.started_at ? run.started_at.strftime('%m/%d %H:%M') : '-' %>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
              <% if run.started_at && run.ended_at %>
                <%= ((run.ended_at - run.started_at) * 1000).round %>ms
              <% else %>
                -
              <% end %>
            </td>
          </tr>
          <% if run.error_message.present? %>
            <tr class="bg-red-50">
              <td colspan="5" class="px-6 py-4">
                <div class="text-sm">
                  <span class="font-medium text-red-800">Error:</span>
                  <pre class="mt-2 text-xs text-red-700 bg-red-100 p-3 rounded overflow-x-auto"><%= run.error_message %></pre>
                </div>
              </td>
            </tr>
          <% end %>
        <% end %>
      </tbody>
    </table>
  </div>
</div>
```

### 13. Form Component

Consistent form styling for edit views.

**Structure:**
```erb
<div class="bg-white rounded-lg shadow-sm p-6">
  <%= form_with(model: @data_flow, local: true) do |form| %>
    <% if @data_flow.errors.any? %>
      <div class="bg-red-50 border-l-4 border-red-400 p-4 mb-6 rounded-r-lg">
        <div class="flex">
          <div class="flex-shrink-0">
            <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
            </svg>
          </div>
          <div class="ml-3">
            <h3 class="text-sm font-medium text-red-800">
              <%= pluralize(@data_flow.errors.count, "error") %> prohibited this data flow from being saved:
            </h3>
            <ul class="mt-2 text-sm text-red-700 list-disc list-inside">
              <% @data_flow.errors.full_messages.each do |message| %>
                <li><%= message %></li>
              <% end %>
            </ul>
          </div>
        </div>
      </div>
    <% end %>

    <div class="space-y-6">
      <div>
        <%= form.label :name, class: "block text-sm font-medium text-gray-700 mb-2" %>
        <%= form.text_field :name, class: "w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500" %>
      </div>

      <div>
        <%= form.label :status, class: "block text-sm font-medium text-gray-700 mb-2" %>
        <%= form.select :status, [['Active', 'active'], ['Inactive', 'inactive']], {}, 
                        class: "w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500" %>
      </div>

      <div class="flex gap-3">
        <%= form.submit "Update Data Flow", class: button_classes(:primary) %>
        <%= link_to "Cancel", data_flow_path(@data_flow), class: button_classes(:secondary) %>
      </div>
    </div>
  <% end %>
</div>
```

## Data Models

No changes to data models are required. The UI rework is purely presentational.

## Error Handling

### View-Level Error Handling

1. **Missing Data**: Use empty state components
2. **Flash Messages**: Already implemented in layout, will be styled with Tailwind
3. **Form Errors**: Not applicable (no forms in current scope)

### Graceful Degradation

- Tables will scroll horizontally on small screens
- Navigation will remain functional without JavaScript
- All interactive elements will have keyboard support

## Testing Strategy

### Manual Testing Checklist

1. **Visual Regression**
   - Compare before/after screenshots of all pages
   - Verify all content is visible and properly styled
   - Check color contrast ratios

2. **Responsive Testing**
   - Test on mobile (320px, 375px, 414px)
   - Test on tablet (768px, 1024px)
   - Test on desktop (1280px, 1920px)

3. **Accessibility Testing**
   - Keyboard navigation through all interactive elements
   - Screen reader compatibility (VoiceOver/NVDA)
   - Color contrast verification (WebAIM Contrast Checker)
   - Focus indicators visible on all interactive elements

4. **Browser Testing**
   - Chrome (latest)
   - Firefox (latest)
   - Safari (latest)
   - Edge (latest)

5. **Functional Testing**
   - All links navigate correctly
   - All buttons trigger correct actions
   - Data displays accurately
   - Flash messages appear correctly

### Automated Testing

While the focus is on visual changes, existing controller and integration tests should continue to pass:

```bash
# Run existing test suite
rails test
```

## Design System Reference

### Color Palette

**Primary Colors:**
- Indigo: `indigo-50` through `indigo-900` (primary brand color)
- Blue: `blue-50` through `blue-900` (products, information)
- Green: `green-50` through `green-900` (success, exports)
- Purple: `purple-50` through `purple-900` (dataflows, transforms)
- Red: `red-50` through `red-900` (danger, errors)
- Yellow: `yellow-50` through `yellow-900` (warnings)

**Neutral Colors:**
- Gray: `gray-50` through `gray-900` (text, backgrounds, borders)
- White: `white`
- Black: `black`

### Typography Scale

- **Headings:**
  - H1: `text-4xl font-bold` (36px)
  - H2: `text-3xl font-bold` (30px)
  - H3: `text-2xl font-semibold` (24px)
  - H4: `text-xl font-semibold` (20px)

- **Body Text:**
  - Large: `text-lg` (18px)
  - Base: `text-base` (16px)
  - Small: `text-sm` (14px)
  - Extra Small: `text-xs` (12px)

- **Font Weights:**
  - Normal: `font-normal` (400)
  - Medium: `font-medium` (500)
  - Semibold: `font-semibold` (600)
  - Bold: `font-bold` (700)

### Spacing Scale

Using Tailwind's default spacing scale (4px base unit):
- `p-2` = 8px
- `p-4` = 16px
- `p-6` = 24px
- `p-8` = 32px
- `gap-4` = 16px
- `gap-6` = 24px
- `gap-8` = 32px

### Border Radius

- Small: `rounded` (4px)
- Medium: `rounded-lg` (8px)
- Large: `rounded-xl` (12px)
- Full: `rounded-full` (9999px)

### Shadows

- Small: `shadow-sm`
- Base: `shadow`
- Medium: `shadow-md`
- Large: `shadow-lg`

### Responsive Breakpoints

- `sm`: 640px
- `md`: 768px
- `lg`: 1024px
- `xl`: 1280px
- `2xl`: 1536px

## Implementation Notes

### Tailwind Installation

The application will need Tailwind CSS installed via the `tailwindcss-rails` gem:

```ruby
# Gemfile
gem "tailwindcss-rails"
```

```bash
bundle install
rails tailwindcss:install
```

### Configuration

The Tailwind config will include:

```javascript
// config/tailwind.config.js
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      // Custom extensions if needed
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
  ]
}
```

### Migration Strategy

1. Install Tailwind CSS
2. Update layout file (already has Tailwind classes)
3. Refactor home/index.html.erb
4. Refactor products/index.html.erb
5. Refactor product_exports/index.html.erb
6. Add helper methods for reusable components
7. Test all pages
8. Remove any unused CSS files

### Accessibility Considerations

1. **Color Contrast**: All text meets WCAG AA standards
   - Normal text: 4.5:1 minimum
   - Large text: 3:1 minimum

2. **Focus Indicators**: All interactive elements have visible focus states
   - Using `focus:ring-2 focus:ring-{color}-500 focus:ring-offset-2`

3. **Semantic HTML**: Proper use of headings, lists, tables
   - Tables use `<thead>`, `<tbody>`, `<th>`, `<td>`
   - Headings follow logical hierarchy

4. **ARIA Labels**: Added where needed for icon-only buttons
   - Example: `aria-label="Trigger heartbeat"`

5. **Keyboard Navigation**: All interactive elements are keyboard accessible
   - Links and buttons are focusable
   - Tab order is logical

## Performance Considerations

1. **CSS Size**: Tailwind's purge feature removes unused classes in production
2. **Asset Loading**: Propshaft handles efficient asset delivery
3. **No JavaScript Required**: All styling is CSS-based, no JS dependencies
4. **Minimal HTTP Requests**: Single CSS file, no external dependencies

## Future Enhancements

Potential improvements beyond the current scope:

1. **Dark Mode**: Add dark mode toggle using Tailwind's dark mode feature
2. **Component Library**: Extract components into ViewComponent or Phlex
3. **Animation**: Add subtle transitions and animations
4. **Custom Icons**: Replace emoji with SVG icon library
5. **Print Styles**: Optimize for printing
6. **Internationalization**: Prepare for multi-language support

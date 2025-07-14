# Nutritionist Views

This directory contains the views for nutritionist users in the DIMA application.

## Files

### `nutritionist_home_screen.dart`

The main home screen for nutritionists with bottom navigation that includes:

- **Dashboard**: Welcome screen with overview
- **Validate Plans**: Page to review and validate meal plans assigned to the nutritionist

### `validate_plans_page.dart`

A page that allows nutritionists to:

- View meal plans assigned to them for validation
- See the validation status of each plan (Pending Review, Validated, Not Validated)
- Validate or reject meal plans with a single click
- Refresh the list to see updated statuses

## Features

### Bottom Navigation

Following the same pattern as the user views, the nutritionist home screen uses a bottom navigation bar with:

- Dashboard icon (inactive: `Icons.dashboard_outlined`, active: `Icons.dashboard`)
- Validate Plans icon (inactive: `Icons.assignment_outlined`, active: `Icons.assignment`)

### Meal Plan Validation

Nutritionists can:

1. View all meal plans assigned to them that need validation
2. See the current validation status with color-coded chips:
   - Orange: Pending Review
   - Green: Validated
   - Grey: Not Validated
3. Validate or reject plans that are in "Pending Review" status
4. Get feedback via snackbar messages for successful/failed operations

### Backend Integration

The validate plans functionality integrates with:

- `listMyAssignedMealPlans` GraphQL query to fetch assigned meal plans
- `validateMealPlan` GraphQL mutation to update validation status
- GSI4 (Global Secondary Index) for efficient querying of nutritionist-assigned meal plans

## Usage

To navigate to the validate plans page:

1. Log in as a nutritionist
2. Tap the "Validate Plans" tab in the bottom navigation
3. Review assigned meal plans
4. Use the "Validate" or "Reject" buttons to update the status

## Architecture

The validate plans page follows the same architecture as user views:

- Uses Riverpod for state management
- Integrates with the `MealPlansProvider` for data operations
- Follows Material Design patterns for UI consistency
- Implements proper error handling and loading states

# Link Actions Feedback - Accessibility Guidelines

## Visual Feedback
- Toast notifications appear with sufficient contrast ratios (green on dark background)
- Icons provide additional visual cues (💾 for save, ✓ for read, 📌 for unread)
- Animations are subtle and don't cause motion sickness
- Flash messages auto-dismiss after 5 seconds but can be manually dismissed

## Keyboard Navigation
- All interactive elements are keyboard accessible
- Flash messages can be dismissed with keyboard (click or Enter)
- Link action buttons maintain focus after interaction

## Screen Reader Support
- Flash messages are announced when they appear
- Status changes (read/unread) are communicated through updated button text
- Confirmation dialogs for destructive actions (delete)

## Animation Preferences
- Animations use CSS transitions that respect `prefers-reduced-motion`
- Durations are kept short (300-500ms) to avoid user frustration
- Visual feedback doesn't rely solely on color changes

## Testing Checklist
- [ ] Test with keyboard-only navigation
- [ ] Test with screen reader (NVDA/JAWS on Windows, VoiceOver on Mac)
- [ ] Test with `prefers-reduced-motion` enabled
- [ ] Verify color contrast meets WCAG AA standards
- [ ] Ensure no flashing content that could trigger seizures
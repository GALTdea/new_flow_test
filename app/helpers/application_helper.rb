module ApplicationHelper
  def application_name
    Rails.configuration.x.application_name
  end

  def field_accessibility(form, attribute, describedby: nil)
    error_id = form.field_id(attribute, :error)
    error_present = form.object.errors[attribute].any?
    description_ids = Array(describedby).compact
    description_ids << error_id if error_present

    {
      aria: {
        describedby: description_ids.presence&.join(" "),
        invalid: error_present ? "true" : nil
      }
    }
  end
end

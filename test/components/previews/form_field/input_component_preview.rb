module FormField
  class InputComponentPreview < ViewComponent::Preview
    def text_input
      render_with_template(locals: { type: :text, field: :name, label: "Name" })
    end

    def email_input
      render_with_template(locals: { type: :email, field: :email, label: "Email" })
    end

    def password_input
      render_with_template(locals: { type: :password, field: :password, label: "Password" })
    end
  end
end

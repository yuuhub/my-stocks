module ApplicationHelper
    def active_class(path)
        "active" if current_page?(path)
    end

    def status_mark(user)
        if user.status == "approved"
            "bx-check-circle"
        elsif user.status == "disapproved"
            "bx-error-circle"
        else
            "bx-minus-circle"
        end
    end
end

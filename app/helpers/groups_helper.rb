module GroupsHelper

  def is_admin_creator?(admin_creator, group, user_id)
    if admin_creator == "admin" && group.admin_id == user_id
      return true
    elsif admin_creator == "creator" && group.creator_id == user_id
      return true
    end
    return false
  end

  def is_admin?(group, user_id)
    is_admin_creator?("admin", group, user_id)
  end

  def is_creator?(group, user_id)
    is_admin_creator?("creator", group, user_id)
  end  

  def is_member?(group, user)
    group.users.include?(user)
  end

end

# frozen_string_literal: true

class UpdatePermissionsForPortfolio < ActiveRecord::Migration[5.0]
  def self.up
    # assign them to Admin role.
    role_admin = Role.find_by_name('Admin')
    role_cust = Role.find_by_name('Customer')
    role_siteowner = Role.find_by_name('Site Owner')

    right = Right.create name: '*Access to all portfolio actions', controller: 'portfolios', action: '*'
    role_admin.rights << right
    role_siteowner.rights << right

    right = Right.create name: '*Access to all artifact actions', controller: 'artifacts', action: '*'
    role_admin.rights << right
    role_siteowner.rights << right

    role_siteowner.save
    role_admin.save
  end

  def self.down
    # Destroy all rights
    right = Right.find_by_name('*Access to all portfolio actions')
    begin
      right.destroy
    rescue StandardError
      puts('Portfolio right not found.')
    end

    right = Right.find_by_name('*Access to all artifact actions')
    begin
      right.destroy
    rescue StandardError
      puts('artifacts right not found.')
    end
  end
end

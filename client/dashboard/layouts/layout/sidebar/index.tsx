import React from 'react'
import { NavLink } from 'react-router-dom'

import '../../../../../app/javascript/stylesheets/application.css'
import classNames from '../../../utils/class-names'

export const Sidebar = (props) => {
  const navigation = props.navigation
  const secondaryNavigation = props.secondaryNavigation
  const site = props.site

  return (
    <div className="hidden lg:flex lg:w-64 lg:flex-col lg:fixed lg:inset-y-0">
      <div className="flex flex-col flex-grow bg-surface-1 overflow-y-auto">
        <div className="bg-surface-1 flex items-center">
          <div className="h-16 px-4 flex items-center flex-shrink-0 grow">
            <img
              className="block h-8 w-auto"
              src={site.logo_url}
              alt={site.name}
            />
            <h1 className="pl-4 typescale-title-large text-on-surface-variant">
              {site.name}
            </h1>
          </div>
        </div>
        <nav
          className="flex-1 flex flex-col divide-y divide-outline overflow-y-auto px-2 pb-4 pt-5"
          aria-label="Sidebar"
        >
          <div className="space-y-1">
            {navigation.map((item) => (
              <NavLink
                key={item.name}
                to={item.href}
                className={({ isActive }) =>
                  classNames(
                    isActive
                      ? 'bg-primary-container text-on-primary-container hover:text-on-primary-container hover:bg-on-primary-container focus:text-on-primary-container focus:bg-on-primary-container'
                      : 'text-on-surface-variant hover:bg-on-surface hover:text-on-surface focus:text-on-surface focus:bg-on-surface',
                    'group flex items-center px-2 py-2 typescale-label-large rounded-md hover:bg-opacity-8 dark:hover:bg-opacity-8 focus:bg-on-primary focus:bg-opacity-12 dark:focus:bg-opacity-12'
                  )
                }
              >
                {({ isActive }) => (
                  <>
                    <item.icon
                      className={classNames(
                        isActive
                          ? 'text-on-primary-container hover:text-on-primary-container focus:text-on-primary-container'
                          : 'text-on-surface-variant group-hover:text-on-surface focus:text-on-surface',
                        'mr-3 flex-shrink-0 h-6 w-6'
                      )}
                      aria-hidden="true"
                    />
                    {item.name}
                  </>
                )}
              </NavLink>
            ))}
          </div>
          <div className="mt-6 pt-6">
            <div className="space-y-1">
              {secondaryNavigation.map((item) => (
                <a
                  key={item.name}
                  href={item.href}
                  className="group flex items-center px-2 py-2 rounded-md typescale-label-large text-on-surface-variant hover:bg-on-surface hover:text-on-surface hover:bg-opacity-8 dark:hover:bg-opacity-8 focus:text-on-surface focus:bg-on-surface focus:bg-opacity-12 dark:focus:bg-opacity-12"
                >
                  <item.icon
                    className="mr-3 flex-shrink h-6 w-6 text-on-surface-variant group-hover:text-on-surface focus:text-on-surface"
                    aria-hidden="true"
                  />
                  {item.name}
                </a>
              ))}
            </div>
          </div>
        </nav>
      </div>
    </div>
  )
}

export default Sidebar

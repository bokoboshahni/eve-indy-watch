import React, { Fragment } from 'react'
import { Dialog, Transition } from '@headlessui/react'
import { NavLink } from 'react-router-dom'
import { XIcon } from '@heroicons/react/outline'

import '../../../../../app/javascript/stylesheets/application.css'
import classNames from '../../../utils/class-names'

export const MobileMenu = (props) => {
  const navigation = props.navigation
  const secondaryNavigation = props.secondaryNavigation
  const sidebarOpen = props.sidebarOpen
  const setSidebarOpen = props.setSidebarOpen
  const site = props.site

  return (
    <Transition.Root show={sidebarOpen} as={Fragment}>
      <Dialog
        as="div"
        className="fixed inset-0 flex z-40 lg:hidden"
        onClose={setSidebarOpen}
      >
        <Transition.Child
          as={Fragment}
          enter="transition-opacity ease-linear duration-300"
          enterFrom="opacity-0"
          enterTo="opacity-100"
          leave="transition-opacity ease-linear duration-300"
          leaveFrom="opacity-100"
          leaveTo="opacity-0"
        >
          <Dialog.Overlay className="fixed inset-0 bg-neutral-600 bg-opacity-75" />
        </Transition.Child>
        <Transition.Child
          as={Fragment}
          enter="transition ease-in-out duration-300 transform"
          enterFrom="-tranneutral-x-full"
          enterTo="tranneutral-x-0"
          leave="transition ease-in-out duration-300 transform"
          leaveFrom="tranneutral-x-0"
          leaveTo="-tranneutral-x-full"
        >
          <div className="relative flex-1 flex flex-col max-w-xs w-full pt-5 pb-4 bg-surface-1">
            <Transition.Child
              as={Fragment}
              enter="ease-in-out duration-300"
              enterFrom="opacity-0"
              enterTo="opacity-100"
              leave="ease-in-out duration-300"
              leaveFrom="opacity-100"
              leaveTo="opacity-0"
            >
              <div className="absolute top-0 right-0 -mr-12 pt-2">
                <button
                  type="button"
                  className="ml-1 flex items-center justify-center h-10 w-10 rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-on-surface"
                  onClick={() => setSidebarOpen(false)}
                >
                  <span className="sr-only">Close sidebar</span>
                  <XIcon
                    className="h-6 w-6 text-on-surface-variant"
                    aria-hidden="true"
                  />
                </button>
              </div>
            </Transition.Child>
            <div className="flex-shrink-0 flex items-center px-4">
              <img
                className="block h-8 w-auto"
                src={site.logo_url}
                alt={site.name}
              />
              <h1 className="pl-4 typescale-title-medium text-on-surface-variant">
                {site.name}
              </h1>
            </div>
            <nav
              className="mt-5 flex-shrink-0 h-full divide-y divide-outline overflow-y-auto px-2 pb-4 pt-5"
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
                              ? 'dark:text-neutral-300'
                              : 'dark:text-neutral-400 dark:group-hover:text-neutral-300',
                            'mr-3 flex-shrink-0 h-6 w-6 text-primary-300'
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
                      className="group flex items-center px-2 py-2 rounded-md typescale-label-large text-on-surface-variant hover:bg-on-surface hover:text-on-surface hover:bg-opacity-8 dark:hover:bg-opacity-8"
                    >
                      <item.icon
                        className="mr-4 h-6 w-6 text-on-surface-variant hover:bg-on-surface hover:text-on-surface hover:bg-opacity-8 dark:hover:bg-opacity-8"
                        aria-hidden="true"
                      />
                      {item.name}
                    </a>
                  ))}
                </div>
              </div>
            </nav>
          </div>
        </Transition.Child>
        <div className="flex-shrink-0 w-14" aria-hidden="true">
          {/* Dummy element to force sidebar to shrink to fit close icon */}
        </div>
      </Dialog>
    </Transition.Root>
  )
}

export default MobileMenu

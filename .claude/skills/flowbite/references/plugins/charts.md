# Charts

Use the chart and graph components from Flowbite built with Tailwind CSS and ApexCharts to choose from line, area, bar, column, pie, and radial charts and customize them using JavaScript

The chart components from the Flowbite Library are open-source under the MIT license and they are styled with the utility classes from Tailwind CSS and based on the open-source [ApexCharts](https://apexcharts.com/) library.

We provide an extensive collection of responsive chart types such as area, bar, column, pie, and radial that can help you visualize complex data inside graphs in admin dashboard layouts, analytics, diagrams, and more.

You can also easily customize the colors, sizes, and options of these charts either via Tailwind CSS directly or via the JavaScript options from the ApexCharts library. Dark mode is also supported by default.

## Area chart

Use this example to show a basic area chart by setting the `type: "area"` option in JavaScript:

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  <div class="flex justify-between items-start">
    <div>
      <h5 class="text-2xl font-semibold text-heading">32.4k</h5>
      <p class="text-body">Users this week</p>
    </div>
    <div class="flex items-center px-2.5 py-0.5 font-medium text-fg-success text-center">
      <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v13m0-13 4 4m-4-4-4 4"/></svg>
      12%
    </div>
  </div>
  <div id="area-chart"></div>
  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownDefaultButton" data-dropdown-toggle="lastDaysdropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="lastDaysdropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownDefaultButton">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Users Report
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>
</div>
```

## Line chart

To create a double line chart check the example below by setting the chart type to `type: "line"` and copy the HTML markup and JS options to automatically style and populate the chart with data:

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  <div class="flex justify-between mb-4 md:mb-6">
    <div class="grid gap-4 grid-cols-2">
      <div>
        <h5 class="inline-flex items-center text-body">Clicks
          <svg data-popover-target="clicks-info" data-popover-placement="bottom" class="w-4 h-4 text-body hover:text-heading cursor-pointer ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.529 9.988a2.502 2.502 0 1 1 5 .191A2.441 2.441 0 0 1 12 12.582V14m-.01 3.008H12M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
          <div data-popover id="clicks-info" role="tooltip" class="absolute z-10 p-3 invisible inline-block text-sm text-body transition-opacity duration-300 bg-neutral-primary-soft border border-default rounded-base shadow-xs opacity-0 w-72">
              <div>
                  <h3 class="font-semibold text-heading mb-2">Activity growth - Incremental</h3>
                  <p class="mb-4">Report helps navigate cumulative growth of community activities. Ideally, the chart should have a growing trend, as stagnating chart signifies a significant decrease of community activity.</p>
                  <h3 class="font-semibold text-heading mb-2">Calculation</h3>
                  <p class="mb-4">For each date bucket, the all-time volume of activities is calculated. This means that activities in period n contain all activities up to period n, plus the activities generated by your community in period.</p>
                  <a href="#" class="flex items-center font-medium text-fg-brand hover:underline">
                      Read more 
                      <svg class="w-4 h-4 ms-1 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
                  </a>
              </div>
              <div data-popper-arrow></div>
          </div>
        </h5>
        <p class="text-heading text-2xl font-semibold">42,3k</p>
      </div>
      <div>
        <h5 class="inline-flex items-center text-body">CPC
          <svg data-popover-target="cpc-info" data-popover-placement="bottom" class="w-4 h-4 text-body hover:text-heading cursor-pointer ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.529 9.988a2.502 2.502 0 1 1 5 .191A2.441 2.441 0 0 1 12 12.582V14m-.01 3.008H12M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
          <div data-popover id="cpc-info" role="tooltip" class="absolute z-10 p-3 invisible inline-block text-sm text-body transition-opacity duration-300 bg-neutral-primary-soft border border-default rounded-base shadow-xs opacity-0 w-72">
              <div>
                  <h3 class="font-semibold text-heading mb-2">CPC Info</h3>
                  <p class="mb-4">Report helps navigate cumulative growth of community activities. Ideally, the chart should have a growing trend, as stagnating chart signifies a significant decrease of community activity.</p>
                  <h3 class="font-semibold text-heading mb-2">Calculation</h3>
                  <p class="mb-4">For each date bucket, the all-time volume of activities is calculated. This means that activities in period n contain all activities up to period n, plus the activities generated by your community in period.</p>
                  <a href="#" class="flex items-center font-medium text-fg-brand hover:underline">
                      Read more 
                      <svg class="w-4 h-4 ms-1 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
                  </a>
              </div>
              <div data-popper-arrow></div>
          </div>
        </h5>
        <p class="text-heading text-2xl font-semibold">$5.40</p>
      </div>
    </div>
    <div>
    <button id="dropdownDefaultButton" data-dropdown-toggle="lastDaysdropdown" data-dropdown-placement="bottom" type="button" class="inline-flex items-center text-body bg-neutral-secondary-medium box-border border border-default-medium hover:bg-neutral-tertiary-medium hover:text-heading focus:ring-4 focus:ring-neutral-tertiary shadow-xs font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
      Last week
      <svg class="w-4 h-4 ms-1.5 -me-0.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
    </button>
    <div id="lastDaysdropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownDefaultButton">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
    </div>
  </div>
  <div id="line-chart"></div>
  <div class="items-center border-light border-t justify-between mt-4 md:mt-6 pt-4 md:pt-6">
    <button type="button" class="inline-flex items-center  text-white bg-brand hover:bg-brand-strong box-border border border-transparent focus:ring-4 focus:ring-brand-medium shadow-xs font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
      <svg class="w-4 h-4 me-1.5 -ms-0.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 3v4a1 1 0 0 1-1 1H5m4 10v-2m3 2v-6m3 6v-3m4-11v16a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1V7.914a1 1 0 0 1 .293-.707l3.914-3.914A1 1 0 0 1 9.914 3H18a1 1 0 0 1 1 1Z"/></svg>
      View full report
    </button>
  </div>
</div>
```

## Column chart

You can represent multiple data entries using columns by setting the `type: "bar"` option and also by updating the `horizontal` key value to `false` in JavaScript to adjust them vertically as columns:

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  <div class="flex justify-between pb-4 mb-4 border-b border-light">
    <div class="flex items-center">
      <div class="w-12 h-12 bg-neutral-primary-medium border border-default-medium flex items-center justify-center rounded-full me-3">
        <svg class="w-7 h-7 text-body" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-width="2" d="M4.5 17H4a1 1 0 0 1-1-1 3 3 0 0 1 3-3h1m0-3.05A2.5 2.5 0 1 1 9 5.5M19.5 17h.5a1 1 0 0 0 1-1 3 3 0 0 0-3-3h-1m0-3.05a2.5 2.5 0 1 0-2-4.45m.5 13.5h-7a1 1 0 0 1-1-1 3 3 0 0 1 3-3h3a3 3 0 0 1 3 3 1 1 0 0 1-1 1Zm-1-9.5a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0Z"/></svg>
      </div>
      <div>
        <h5 class="text-2xl font-semibold text-heading">3.4k</h5>
        <p class="text-sm text-body">Leads generated per week</p>
      </div>
    </div>
    <div>
      <span class="inline-flex items-center bg-success-soft border border-success-subtle text-fg-success-strong text-xs font-medium px-1.5 py-0.5 rounded">
        <svg class="w-4 h-4 me-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v13m0-13 4 4m-4-4-4 4"/></svg>
        42.5%
      </span>
    </div>
  </div>

  <div class="grid grid-cols-2">
    <dl class="flex items-center">
        <dt class="text-body text-sm font-normal me-1">Money spent:</dt>
        <dd class="text-heading text-sm font-semibold">$3,232</dd>
    </dl>
    <dl class="flex items-center justify-end">
        <dt class="text-body text-sm font-normal me-1">Conversion:</dt>
        <dd class="text-heading text-sm font-semibold">1.2%</dd>
    </dl>
  </div>
  <div id="column-chart"></div>
  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownLastDaysButton" data-dropdown-toggle="LastDaysdropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="LastDaysdropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownLastDaysButton">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Leads Report
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>
</div>
```

## Bar chart

Create a horizontal bar chart with as many data series as you like by setting the `type: "bar"` chart type via JavaScript and copy the example below into your project. You can enable or disable the labels on the X or Y axis by setting `show` to `false` for the `xaxis` and `yaxis` objects of the chart options.

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  <div class="flex justify-between border-light border-b pb-3">
    <dl>
      <dt class="text-body">Profit</dt>
      <dd class="text-2xl font-semibold text-heading">$5,405</dd>
    </dl>
    <div>
      <span class="inline-flex items-center bg-success-soft border border-success-subtle text-fg-success-strong text-xs font-medium px-1.5 py-0.5 rounded">
        <svg class="w-4 h-4 me-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v13m0-13 4 4m-4-4-4 4"/></svg>
        Profit rate 23.5%
      </span>
    </div>
  </div>

  <div class="grid grid-cols-2 py-3">
    <dl>
      <dt class="text-body">Income</dt>
      <dd class="text-lg font-semibold text-fg-success">$23,635</dd>
    </dl>
    <dl>
      <dt class="text-body">Expense</dt>
      <dd class="text-lg font-semibold text-fg-danger">-$18,230</dd>
    </dl>
  </div>

  <div id="bar-chart"></div>
    
  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownLastDays3Button" data-dropdown-toggle="LastDays3dropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="LastDays3dropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownLastDays3Button">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Revenue Report
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>
</div>
```

## Pie chart

Create a pie chart with multiple data series by setting the `type: "pie"` chart type option via JavaScript and copy the following HTML markup code and options from below:

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">

  <div class="flex justify-between items-start w-full">
      <div class="flex-col items-center">
        <div class="flex items-center mb-1">
          <h5 class="text-xl font-semibold text-heading me-1">Website traffic</h5>
          <svg data-popover-target="traffic-info" data-popover-placement="bottom" class="w-4 h-4 text-body hover:text-heading cursor-pointer ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.529 9.988a2.502 2.502 0 1 1 5 .191A2.441 2.441 0 0 1 12 12.582V14m-.01 3.008H12M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
          <div data-popover id="traffic-info" role="tooltip" class="absolute z-10 p-3 invisible inline-block text-sm text-body transition-opacity duration-300 bg-neutral-primary-soft border border-default rounded-base shadow-xs opacity-0 w-72">
              <div>
                  <h3 class="font-semibold text-heading mb-2">Activity growth - Incremental</h3>
                  <p class="mb-4">Report helps navigate cumulative growth of community activities. Ideally, the chart should have a growing trend, as stagnating chart signifies a significant decrease of community activity.</p>
                  <h3 class="font-semibold text-heading mb-2">Calculation</h3>
                  <p class="mb-4">For each date bucket, the all-time volume of activities is calculated. This means that activities in period n contain all activities up to period n, plus the activities generated by your community in period.</p>
                  <a href="#" class="flex items-center font-medium text-fg-brand hover:underline">
                      Read more 
                      <svg class="w-4 h-4 ms-1 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
                  </a>
              </div>
              <div data-popper-arrow></div>
          </div>
      </div>
      <button id="dateRangeButton" data-dropdown-toggle="dateRangeDropdown" data-dropdown-ignore-click-outside-class="datepicker" type="button" class="inline-flex items-center text-fg-brand font-medium hover:underline">
        31 Nov - 31 Dev 
        <svg class="w-4.5 h-4.5 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <div id="dateRangeDropdown" class="z-10 hidden bg-neutral-primary-soft rounded-base shadow-xs border border-default w-80 lg:w-112">
        <div id="date-range-picker" date-rangepicker class="flex items-center p-2">
          <div class="relative">
            <div class="absolute inset-y-0 start-0 flex items-center ps-3 pointer-events-none">
                <svg class="w-4 h-4 text-body" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 10h16m-8-3V4M7 7V4m10 3V4M5 20h14a1 1 0 0 0 1-1V7a1 1 0 0 0-1-1H5a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1Zm3-7h.01v.01H8V13Zm4 0h.01v.01H12V13Zm4 0h.01v.01H16V13Zm-8 4h.01v.01H8V17Zm4 0h.01v.01H12V17Zm4 0h.01v.01H16V17Z"/></svg>
            </div>
            <input id="datepicker-range-start" name="start" type="text" class="block w-full ps-9 pe-3 py-2.5 bg-neutral-secondary-medium border border-default-medium text-heading text-sm rounded-base focus:ring-brand focus:border-brand px-3 py-2.5 shadow-xs placeholder:text-body" placeholder="Start date">
          </div>
          <span class="mx-4 text-body">to</span>
          <div class="relative">
            <div class="absolute inset-y-0 start-0 flex items-center ps-3 pointer-events-none">
                <svg class="w-4 h-4 text-body" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 10h16m-8-3V4M7 7V4m10 3V4M5 20h14a1 1 0 0 0 1-1V7a1 1 0 0 0-1-1H5a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1Zm3-7h.01v.01H8V13Zm4 0h.01v.01H12V13Zm4 0h.01v.01H16V13Zm-8 4h.01v.01H8V17Zm4 0h.01v.01H12V17Zm4 0h.01v.01H16V17Z"/></svg>
            </div>
            <input id="datepicker-range-end" name="end" type="text" class="block w-full ps-9 pe-3 py-2.5 bg-neutral-secondary-medium border border-default-medium text-heading text-sm rounded-base focus:ring-brand focus:border-brand px-3 py-2.5 shadow-xs placeholder:text-body" placeholder="End date">
        </div>
        </div>
      </div>
    </div>
    <div class="flex justify-end items-center">
      <button id="widgetDropdownButton" data-dropdown-toggle="widgetDropdown" data-dropdown-placement="bottom" type="button" class="inline-flex items-center justify-center text-body bg-neutral-primary-soft hover:bg-neutral-tertiary hover:text-heading focus:ring-4 focus:ring-neutral-tertiary shadow-xs font-medium leading-5 rounded-base text-sm w-9 h-9 focus:outline-none">
        <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-width="3" d="M6 12h.01m6 0h.01m5.99 0h.01"/></svg>
        <span class="sr-only">Open dropdown</span>
      </button>
      <div id="widgetDropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="widgetDropdownButton">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">
                <svg class="w-4 h-4 me-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 5V4a1 1 0 0 0-1-1H8.914a1 1 0 0 0-.707.293L4.293 7.207A1 1 0 0 0 4 7.914V20a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-5M9 3v4a1 1 0 0 1-1 1H4m11.383.772 2.745 2.746m1.215-3.906a2.089 2.089 0 0 1 0 2.953l-6.65 6.646L9 17.95l.739-3.692 6.646-6.646a2.087 2.087 0 0 1 2.958 0Z"/></svg>
                Edit widget
              </a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">
                <svg class="w-4 h-4 me-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 13V4M7 14H5a1 1 0 0 0-1 1v4a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1v-4a1 1 0 0 0-1-1h-2m-1-5-4 5-4-5m9 8h.01"/></svg>
                Download data
              </a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">
                <svg class="w-4 h-4 me-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 8v8m0-8a2 2 0 1 0 0-4 2 2 0 0 0 0 4Zm0 8a2 2 0 1 0 0 4 2 2 0 0 0 0-4Zm8-8a2 2 0 1 0 0-4 2 2 0 0 0 0 4Zm0 0a4 4 0 0 1-4 4h-1a3 3 0 0 0-3 3"/></svg>
                Add to repository
              </a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">
                <svg class="w-4 h-4 me-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 7h14m-9 3v8m4-8v8M10 3h4a1 1 0 0 1 1 1v3H9V4a1 1 0 0 1 1-1ZM6 7h12v13a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V7Z"/></svg>
                Delete widget
              </a>
            </li>
          </ul>
    </div>
  </div>
  </div>

  <!-- Line Chart -->
  <div class="py-6" id="pie-chart"></div>

  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownLastDays4Button" data-dropdown-toggle="LastDays4dropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="LastDays4dropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownLastDays4Button">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Traffic Report
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>

</div>
```

## Donut chart

Set the JavaScript API option to `type: "donut"` to create a donut chart and copy the options from the example below to style the elements such as the data series, legends and labels for the X and Y axis.

In this example we also show how you can set event listeners on the UI components from Flowbite to update the data series from the chart by clicking the device checkboxes.

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  
  <div class="flex justify-between mb-3">
        <div class="flex justify-center items-center">
          <h5 class="text-xl font-semibold text-heading me-1">Website traffic</h5>
          <svg data-popover-target="traffic-info-2" data-popover-placement="bottom" class="w-4 h-4 text-body hover:text-heading cursor-pointer ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.529 9.988a2.502 2.502 0 1 1 5 .191A2.441 2.441 0 0 1 12 12.582V14m-.01 3.008H12M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
          <div data-popover id="traffic-info-2" role="tooltip" class="absolute z-10 p-3 invisible inline-block text-sm text-body transition-opacity duration-300 bg-neutral-primary-soft border border-default rounded-base shadow-xs opacity-0 w-72">
          <div>
            <h3 class="font-semibold text-heading mb-2">Activity growth - Incremental</h3>
            <p class="mb-4">Report helps navigate cumulative growth of community activities. Ideally, the chart should have a growing trend, as stagnating chart signifies a significant decrease of community activity.</p>
            <h3 class="font-semibold text-heading mb-2">Calculation</h3>
            <p class="mb-4">For each date bucket, the all-time volume of activities is calculated. This means that activities in period n contain all activities up to period n, plus the activities generated by your community in period.</p>
                <a href="#" class="flex items-center font-medium text-fg-brand hover:underline">
                  Read more 
                  <svg class="w-4 h-4 ms-1 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
                </a>
          </div>
          <div data-popper-arrow></div>
          </div>
        </div>
      <div>
        <button type="button" data-tooltip-target="data-tooltip" data-tooltip-placement="bottom" class="hidden sm:inline-flex items-center justify-center text-body hover:text-heading bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm w-9 h-9 focus:outline-none">
          <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 15v2a3 3 0 0 0 3 3h10a3 3 0 0 0 3-3v-2m-8 1V4m0 12-4-4m4 4 4-4"/></svg>
          <span class="sr-only">Download data</span>
        </button>
        <div id="data-tooltip" role="tooltip" class="absolute z-10 invisible inline-block px-3 py-2 text-sm font-medium text-white transition-opacity duration-300 bg-dark rounded-base shadow-xs opacity-0 tooltip">
            Download CSV
            <div class="tooltip-arrow" data-popper-arrow></div>
        </div>
      </div>
  </div>

  <div>
    <div class="flex" id="devices">
      <div class="flex items-center me-4">
          <input id="desktop" type="checkbox" value="desktop" class="w-4 h-4 border border-default-medium rounded-xs bg-neutral-secondary-medium focus:ring-2 focus:ring-brand-soft">
          <label for="desktop" class="select-none ms-2 text-sm font-medium text-heading">Desktop</label>
      </div>
      <div class="flex items-center me-4">
          <input id="tablet" type="checkbox" value="tablet" class="w-4 h-4 border border-default-medium rounded-xs bg-neutral-secondary-medium focus:ring-2 focus:ring-brand-soft">
          <label for="tablet" class="select-none ms-2 text-sm font-medium text-heading">Tablet</label>
      </div>
      <div class="flex items-center me-4">
          <input id="mobile" type="checkbox" value="mobile" class="w-4 h-4 border border-default-medium rounded-xs bg-neutral-secondary-medium focus:ring-2 focus:ring-brand-soft">
          <label for="mobile" class="select-none ms-2 text-sm font-medium text-heading">Mobile</label>
      </div>
    </div>
  </div>

  <!-- Donut Chart -->
  <div class="py-6" id="donut-chart"></div>

  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownLastDays5Button" data-dropdown-toggle="LastDays5dropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="LastDays5dropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownLastDays5Button">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Traffic analysis
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>
</div>
```

## Radial chart

To create a radial chart with multiple data entries you need to set the `type: "radialBar"` when initialising a new chart and introduce multiple series and labels to the options and copy the following code:

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  <div class="flex justify-between mb-4 md:mb-6">
    <div class="flex items-center">
      <div class="flex justify-center items-center">
        <h5 class="text-xl font-semibold text-heading me-1">Your team's progress</h5>
          <svg data-popover-target="team-progress-2" data-popover-placement="bottom" class="w-4 h-4 text-body hover:text-heading cursor-pointer ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.529 9.988a2.502 2.502 0 1 1 5 .191A2.441 2.441 0 0 1 12 12.582V14m-.01 3.008H12M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
          <div data-popover id="team-progress-2" role="tooltip" class="absolute z-10 p-3 invisible inline-block text-sm text-body transition-opacity duration-300 bg-neutral-primary-soft border border-default rounded-base shadow-xs opacity-0 w-72">
          <div>
            <h3 class="font-semibold text-heading mb-2">Activity growth - Incremental</h3>
            <p class="mb-4">Report helps navigate cumulative growth of community activities. Ideally, the chart should have a growing trend, as stagnating chart signifies a significant decrease of community activity.</p>
            <h3 class="font-semibold text-heading mb-2">Calculation</h3>
            <p class="mb-4">For each date bucket, the all-time volume of activities is calculated. This means that activities in period n contain all activities up to period n, plus the activities generated by your community in period.</p>
                <a href="#" class="flex items-center font-medium text-fg-brand hover:underline">
                  Read more 
                  <svg class="w-4 h-4 ms-1 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
                </a>
          </div>
          <div data-popper-arrow></div>
        </div>
      </div>
    </div>
  </div>

  <div class="bg-neutral-secondary-medium border border-light-medium p-3 rounded-base">
    <div class="grid grid-cols-3 gap-3 mb-3">
      <dl class="bg-brand-softer border border-brand-subtle text-fg-brand-strong rounded-base flex flex-col items-center justify-center h-[78px]">
        <dt class="w-8 h-8 rounded-full bg-brand-soft text-fg-brand-strong text-sm font-medium flex items-center justify-center mb-1">12</dt>
        <dd class="text-fg-brand text-sm font-medium">To do</dd>
      </dl>
      <dl class="bg-warning-soft border border-warning-subtle text-fg-warning rounded-base flex flex-col items-center justify-center h-[78px]">
        <dt class="w-8 h-8 rounded-full bg-warning-medium text-fg-warning text-sm font-medium flex items-center justify-center mb-1">23</dt>
        <dd class="text-fg-warning text-sm font-medium">In progress</dd>
      </dl>
      <dl class="bg-success-soft border border-success-subtle text-fg-success-strong rounded-base flex flex-col items-center justify-center h-[78px]">
        <dt class="w-8 h-8 rounded-full bg-success-medium text-fg-success-strong text-sm font-medium flex items-center justify-center mb-1">64</dt>
        <dd class="text-fg-success-strong text-sm font-medium">Done</dd>
      </dl>
    </div>
    <button data-collapse-toggle="more-details" type="button" class="hover:underline text-sm text-body font-medium inline-flex items-center">
      Show more details 
      <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
    </button>
    <div id="more-details" class="border-light border-t pt-3 mt-3 space-y-2 hidden">
      <dl class="flex items-center justify-between">
        <dt class="text-body text-sm font-normal">Average task completion rate:</dt>
        <dd class="inline-flex items-center bg-success-soft border border-success-subtle text-fg-success-strong text-xs font-medium px-1.5 py-0.5 rounded">
          <svg class="w-4 h-4 me-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v13m0-13 4 4m-4-4-4 4"/></svg>
          57%
        </dd>
      </dl>
      <dl class="flex items-center justify-between">
        <dt class="text-body text-sm font-normal">Days until sprint ends:</dt>
        <dd class="inline-flex items-center bg-neutral-primary-medium border border-default-medium text-heading text-xs font-medium px-1.5 py-0.5 rounded">13 days</dd>
      </dl>
      <dl class="flex items-center justify-between">
        <dt class="text-body text-sm font-normal">Next meeting:</dt>
        <dd class="inline-flex items-center bg-neutral-primary-medium border border-default-medium text-heading text-xs font-medium px-1.5 py-0.5 rounded">
          <svg class="w-3.5 h-3.5 me-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 10h16m-8-3V4M7 7V4m10 3V4M5 20h14a1 1 0 0 0 1-1V7a1 1 0 0 0-1-1H5a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1Zm3-7h.01v.01H8V13Zm4 0h.01v.01H12V13Zm4 0h.01v.01H16V13Zm-8 4h.01v.01H8V17Zm4 0h.01v.01H12V17Zm4 0h.01v.01H16V17Z"/></svg>
          Thursday
        </dd>
      </dl>
    </div>
  </div>

  <!-- Radial Chart -->
  <div class="py-6" id="radial-chart"></div>

  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownLastDays6Button" data-dropdown-toggle="LastDays6dropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="LastDays6dropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownLastDays6Button">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Progress report
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>
</div>
```

## Options

Learn more about how you can customize the charts including the data, labels, legend indicators, size and appearance of the graphs, and other options by checking out the examples below.

### Data series

You can add multiple data sets by using the `series` object and setting a name, array of data and custom color of choice. In this example we added two data series based on a blue and purple color.

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  <div class="flex justify-between">
    <div>
      <h5 class="text-2xl font-bold text-heading">$12,423</h5>
      <p class="text-body">Sales this week</p>
    </div>
    <div class="flex items-center px-2.5 py-0.5 font-medium text-fg-success text-center">
      <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v13m0-13 4 4m-4-4-4 4"/></svg>
      12%
    </div>
  </div>
  <div id="data-series-chart"></div>
  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownLastDays8Button" data-dropdown-toggle="LastDays8dropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="LastDays8dropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownLastDays8Button">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Progress report
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>
</div>
```

### Labels

Show labels for the X and Y axis by enabling the `xaxis: {show: true}` and `yaxis: {show: true}` and customize the appearance of the labels by adding Tailwind CSS utility classes to the `cssClass` object based on the following example:

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  <div class="flex justify-between">
    <div>
      <h5 class="text-2xl font-bold text-heading">$12,423</h5>
      <p class="text-body">Sales this week</p>
    </div>
    <div class="flex items-center px-2.5 py-0.5 font-medium text-fg-success text-center">
      <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v13m0-13 4 4m-4-4-4 4"/></svg>
      12%
    </div>
  </div>
  <div id="labels-chart" class="py-4 md:py-6"></div>
  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownLastDays9Button" data-dropdown-toggle="LastDays9dropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="LastDays9dropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownLastDays9Button">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Progress report
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>
</div>
```

### Legends

Automatically show the legend indicators of the chart by setting the `legend: { show: true }` value when configuring the options via JavaScript. You can also set position of the legend by using the `position: {x}` option inside the legend object to place it to the top or bottom side of the chart.  

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  <div class="flex justify-between">
    <div>
      <h5 class="text-2xl font-bold text-heading">$12,423</h5>
      <p class="text-body">Sales this week</p>
    </div>
    <div class="flex items-center px-2.5 py-0.5 font-medium text-fg-success text-center">
      <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v13m0-13 4 4m-4-4-4 4"/></svg>
      12%
    </div>
  </div>
  <div id="legend-chart" class="py-4 md:py-6"></div>
  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownLastDays10Button" data-dropdown-toggle="LastDays10dropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="LastDays10dropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownLastDays10Button">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Progress report
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>
</div>
```

### Tooltip

Enable the tooltip that is shown when hovering over a data set by setting `{tooltip: {enabled: true}}` and customize the tooltip component via the following options:

- `x: {show: false}` will show or hide the X axis data
- `y: {show: true}` will show or hide the Y axis data

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  <div class="flex justify-between">
    <div>
      <h5 class="text-2xl font-bold text-heading">$12,423</h5>
      <p class="text-body">Sales this week</p>
    </div>
    <div class="flex items-center px-2.5 py-0.5 font-medium text-fg-success text-center">
      <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v13m0-13 4 4m-4-4-4 4"/></svg>
      12%
    </div>
  </div>
  <div id="tooltip-chart" class="py-4 md:py-6"></div>
  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownLastDays11Button" data-dropdown-toggle="LastDays11dropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="LastDays11dropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownLastDays11Button">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Progress report
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>
</div>
```

### Grid

Add a grid layout of dashed lines to improve the readability of the data entries for the charts by configuring the `{grid: { show: true }}` object and customize the appearance via the `strokeDashArray` object.

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  <div class="flex justify-between">
    <div>
      <h5 class="text-2xl font-bold text-heading">$12,423</h5>
      <p class="text-body">Sales this week</p>
    </div>
    <div class="flex items-center px-2.5 py-0.5 font-medium text-fg-success text-center">
      <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v13m0-13 4 4m-4-4-4 4"/></svg>
      12%
    </div>
  </div>
  <div id="grid-chart" class="py-4 md:py-6"></div>
  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownLastDays12Button" data-dropdown-toggle="LastDays12dropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="LastDays12dropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownLastDays12Button">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Progress report
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>
</div>
```

### Data labels

Show data points on the chart by enable the `dataLabels: {enabled: true}` object when configuring the options via JavaScript and customize the appearance based on the following example:

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  <div class="flex justify-between">
    <div>
      <h5 class="text-2xl font-bold text-heading">$12,423</h5>
      <p class="text-body">Sales this week</p>
    </div>
    <div class="flex items-center px-2.5 py-0.5 font-medium text-fg-success text-center">
      <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v13m0-13 4 4m-4-4-4 4"/></svg>
      12%
    </div>
  </div>
  <div id="data-labels-chart" class="py-4 md:py-6"></div>
  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownLastDays13Button" data-dropdown-toggle="LastDays13dropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="LastDays13dropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownLastDays13Button">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Progress report
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>
</div>
```

### Format data

If you want to format and prefix your data with something such as a currency sign you can do that by using the `formatter` function. For example, here we use the euro ("€") sign instead of the dollar ("$").

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  <div class="flex justify-between">
    <div>
      <h5 class="text-2xl font-bold text-heading">$12,423</h5>
      <p class="text-body">Sales this week</p>
    </div>
    <div class="flex items-center px-2.5 py-0.5 font-medium text-fg-success text-center">
      <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v13m0-13 4 4m-4-4-4 4"/></svg>
      12%
    </div>
  </div>
  <div id="main-chart" class="py-4 md:py-6"></div>
  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownLastDays14Button" data-dropdown-toggle="LastDays14dropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="LastDays14dropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownLastDays14Button">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Progress report
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>
</div>
```

### Chart size

You can set the size (width and height) of the chart by passing the `width: {size}` and `height: {size}` options via JavaScript to the chart object using pixels or percentages:

```html
<div class="max-w-sm w-full bg-neutral-primary-soft border border-default rounded-base shadow-xs p-4 md:p-6">
  <div class="flex justify-between">
    <div>
      <h5 class="text-2xl font-bold text-heading">$12,423</h5>
      <p class="text-body">Sales this week</p>
    </div>
    <div class="flex items-center px-2.5 py-0.5 font-medium text-fg-success text-center">
      <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v13m0-13 4 4m-4-4-4 4"/></svg>
      12%
    </div>
  </div>
  <div id="size-chart" class="[&>div]:mx-auto py-4 md:py-6"></div>
  <div class="grid grid-cols-1 items-center border-light border-t justify-between">
    <div class="flex justify-between items-center pt-4 md:pt-6">
      <!-- Button -->
      <button id="dropdownLastDays15Button" data-dropdown-toggle="LastDays15dropdown" data-dropdown-placement="bottom" class="text-sm font-medium text-body hover:text-heading text-center inline-flex items-center" type="button">
          Last 7 days
          <svg class="w-4 h-4 ms-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 9-7 7-7-7"/></svg>
      </button>
      <!-- Dropdown menu -->
      <div id="LastDays15dropdown" class="z-10 hidden bg-neutral-primary-medium border border-default-medium rounded-base shadow-lg w-44">
          <ul class="p-2 text-sm text-body font-medium" aria-labelledby="dropdownLastDays15Button">
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Yesterday</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Today</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 7 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 30 days</a>
            </li>
            <li>
              <a href="#" class="inline-flex items-center w-full p-2 hover:bg-neutral-tertiary-medium hover:text-heading rounded">Last 90 days</a>
            </li>
          </ul>
      </div>
      <a href="#" class="inline-flex items-center text-fg-brand bg-transparent box-border border border-transparent hover:bg-neutral-secondary-medium focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-3 py-2 focus:outline-none">
        Progress report
        <svg class="w-4 h-4 ms-1.5 -me-0.5 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 12H5m14 0-4 4m4-4-4-4"/></svg>
      </a>
    </div>
  </div>
</div>
```

## JavaScript behaviour

With the charts from Flowbite and through the API of ApexCharts you can programmatically configure and handle the behaviour of the components by using the methods directly on the chart object.

For example, here's how you can initialize a new chart with an options object and call the `render()` function:

```javascript
const chart = new ApexCharts(el, options);
chart.render();
```

You can also update the options or data on demand. Here's an example how you can add or remove data:

```javascript
const chart = new ApexCharts(el, options);

chart.updateSeries([{
  data: [342, 442, 311, 421, 212]
}]);
```

You can also toggle the visibility of a data series by calling the `toggleSeries()` method:

```javascript
const chart = new ApexCharts(el, {
  series: [{
    name: 'Developer Edition'
    data: [342, 442, 311, 421, 212]
  }, {
    name: 'Designer Edition'
    data: [342, 442, 311, 421, 212]
  }]
});

chart.toggleSeries('Designer Edition');
```

You can read more about all of the methods by checking out the official <a href="https://apexcharts.com/docs/methods/#render" rel="nofollow">ApexCharts documentation</a>.

## More examples

Check out more chart examples built with Flowbite, Tailwind CSS and Flowbite with these resources:

- [Flowbite Admin Dashboard](https://github.com/themesberg/flowbite-admin-dashboard)
# Datatables

Use the datatable component to search, sort, filter, export and paginate table data of rows and columns for your web application coded with the utility classes from Tailwind CSS

The datatable component examples from Flowbite are open-source under the MIT License and they are based on the [simple-datatables](https://github.com/fiduswriter/simple-datatables) repository from GitHub which you need to install via NPM or CDN.

This page provides multiple examples of datatable components where you can search, sort, filter, paginate and export table data up to thousands of entries coded with Tailwind CSS and leveraging JavaScript code provided by the parent library.

All examples are responsive, dark mode and RTL support included and by installing the Flowbite plugin the custom styles will automatically be applied to the datatable components using Tailwind CSS.

## Default datatable

Use this example to show table data with default sorting and pagination functionalities.

```html
<table id="default-table">
    <thead>
        <tr>
            <th>
                <span class="flex items-center">
                    Name
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th data-type="date" data-format="YYYY/DD/MM">
                <span class="flex items-center">
                    Release Date
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    NPM Downloads
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Growth
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Flowbite</td>
            <td>2021/25/09</td>
            <td>269000</td>
            <td>49%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">React</td>
            <td>2013/24/05</td>
            <td>4500000</td>
            <td>24%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Angular</td>
            <td>2010/20/09</td>
            <td>2800000</td>
            <td>17%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Vue</td>
            <td>2014/12/02</td>
            <td>3600000</td>
            <td>30%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Svelte</td>
            <td>2016/26/11</td>
            <td>1200000</td>
            <td>57%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Ember</td>
            <td>2011/08/12</td>
            <td>500000</td>
            <td>44%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Backbone</td>
            <td>2010/13/10</td>
            <td>300000</td>
            <td>9%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">jQuery</td>
            <td>2006/28/01</td>
            <td>6000000</td>
            <td>5%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Bootstrap</td>
            <td>2011/19/08</td>
            <td>1800000</td>
            <td>12%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Foundation</td>
            <td>2011/23/09</td>
            <td>700000</td>
            <td>8%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Bulma</td>
            <td>2016/24/10</td>
            <td>500000</td>
            <td>7%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Next.js</td>
            <td>2016/25/10</td>
            <td>2300000</td>
            <td>45%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Nuxt.js</td>
            <td>2016/16/10</td>
            <td>900000</td>
            <td>50%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Meteor</td>
            <td>2012/17/01</td>
            <td>1000000</td>
            <td>10%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Aurelia</td>
            <td>2015/08/07</td>
            <td>200000</td>
            <td>20%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Inferno</td>
            <td>2016/27/09</td>
            <td>100000</td>
            <td>35%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Preact</td>
            <td>2015/16/08</td>
            <td>600000</td>
            <td>28%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Lit</td>
            <td>2018/28/05</td>
            <td>400000</td>
            <td>60%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Alpine.js</td>
            <td>2019/02/11</td>
            <td>300000</td>
            <td>70%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Stimulus</td>
            <td>2018/06/03</td>
            <td>150000</td>
            <td>25%</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Solid</td>
            <td>2021/05/07</td>
            <td>250000</td>
            <td>80%</td>
        </tr>
    </tbody>
</table>
```

## Table search

Set the `searchable` option to `true` to enable the search functionality for all table data.

```html
<table id="search-table">
    <thead>
        <tr>
            <th>
                <span class="flex items-center">
                    Company Name
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Ticker
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Stock Price
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Market Capitalization
                </span>
            </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Apple Inc.</td>
            <td>AAPL</td>
            <td>$192.58</td>
            <td>$3.04T</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Microsoft Corporation</td>
            <td>MSFT</td>
            <td>$340.54</td>
            <td>$2.56T</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Alphabet Inc.</td>
            <td>GOOGL</td>
            <td>$134.12</td>
            <td>$1.72T</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Amazon.com Inc.</td>
            <td>AMZN</td>
            <td>$138.01</td>
            <td>$1.42T</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">NVIDIA Corporation</td>
            <td>NVDA</td>
            <td>$466.19</td>
            <td>$1.16T</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Tesla Inc.</td>
            <td>TSLA</td>
            <td>$255.98</td>
            <td>$811.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Meta Platforms Inc.</td>
            <td>META</td>
            <td>$311.71</td>
            <td>$816.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Berkshire Hathaway Inc.</td>
            <td>BRK.B</td>
            <td>$354.08</td>
            <td>$783.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">TSMC</td>
            <td>TSM</td>
            <td>$103.51</td>
            <td>$538.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">UnitedHealth Group Incorporated</td>
            <td>UNH</td>
            <td>$501.96</td>
            <td>$466.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Johnson & Johnson</td>
            <td>JNJ</td>
            <td>$172.85</td>
            <td>$452.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">JPMorgan Chase & Co.</td>
            <td>JPM</td>
            <td>$150.23</td>
            <td>$431.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Visa Inc.</td>
            <td>V</td>
            <td>$246.39</td>
            <td>$519.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Eli Lilly and Company</td>
            <td>LLY</td>
            <td>$582.97</td>
            <td>$552.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Walmart Inc.</td>
            <td>WMT</td>
            <td>$159.67</td>
            <td>$429.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Samsung Electronics Co., Ltd.</td>
            <td>005930.KS</td>
            <td>$70.22</td>
            <td>$429.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Procter & Gamble Co.</td>
            <td>PG</td>
            <td>$156.47</td>
            <td>$366.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Nestlé S.A.</td>
            <td>NESN.SW</td>
            <td>$120.51</td>
            <td>$338.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Roche Holding AG</td>
            <td>ROG.SW</td>
            <td>$296.00</td>
            <td>$317.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Chevron Corporation</td>
            <td>CVX</td>
            <td>$160.92</td>
            <td>$310.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">LVMH Moët Hennessy Louis Vuitton</td>
            <td>MC.PA</td>
            <td>$956.60</td>
            <td>$478.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Pfizer Inc.</td>
            <td>PFE</td>
            <td>$35.95</td>
            <td>$200.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Novo Nordisk A/S</td>
            <td>NVO</td>
            <td>$189.15</td>
            <td>$443.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">PepsiCo, Inc.</td>
            <td>PEP</td>
            <td>$182.56</td>
            <td>$311.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">ASML Holding N.V.</td>
            <td>ASML</td>
            <td>$665.72</td>
            <td>$273.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">The Coca-Cola Company</td>
            <td>KO</td>
            <td>$61.37</td>
            <td>$265.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Oracle Corporation</td>
            <td>ORCL</td>
            <td>$118.36</td>
            <td>$319.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Merck & Co., Inc.</td>
            <td>MRK</td>
            <td>$109.12</td>
            <td>$276.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Broadcom Inc.</td>
            <td>AVGO</td>
            <td>$861.80</td>
            <td>$356.00B</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Mastercard Incorporated</td>
            <td>MA</td>
            <td>$421.44</td>
            <td>$396.00B</td>
        </tr>
    </tbody>
</table>

```

## Filtering data

To enable filtering data based on a search query for each column you need to copy the custom code from the JavaScript tab and the HTML structure of the table. Enabling search for each individual data column is an advanced way of letting users browse complex data.

```html
<table id="filter-table">
    <thead>
        <tr>
            <th>
                <span class="flex items-center">
                    Name
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Category
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Brand
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Price
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Stock
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Total Sales
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Status
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Apple iMac</td>
            <td>Computers</td>
            <td>Apple</td>
            <td>$1,299</td>
            <td>50</td>
            <td>200</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Apple iPhone</td>
            <td>Mobile Phones</td>
            <td>Apple</td>
            <td>$999</td>
            <td>120</td>
            <td>300</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Samsung Galaxy</td>
            <td>Mobile Phones</td>
            <td>Samsung</td>
            <td>$899</td>
            <td>80</td>
            <td>150</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Dell XPS 13</td>
            <td>Computers</td>
            <td>Dell</td>
            <td>$1,099</td>
            <td>30</td>
            <td>120</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">HP Spectre x360</td>
            <td>Computers</td>
            <td>HP</td>
            <td>$1,299</td>
            <td>25</td>
            <td>80</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Google Pixel 6</td>
            <td>Mobile Phones</td>
            <td>Google</td>
            <td>$799</td>
            <td>100</td>
            <td>200</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Sony WH-1000XM4</td>
            <td>Headphones</td>
            <td>Sony</td>
            <td>$349</td>
            <td>60</td>
            <td>150</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Apple AirPods Pro</td>
            <td>Headphones</td>
            <td>Apple</td>
            <td>$249</td>
            <td>200</td>
            <td>300</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Asus ROG Zephyrus</td>
            <td>Computers</td>
            <td>Asus</td>
            <td>$1,899</td>
            <td>15</td>
            <td>50</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Microsoft Surface Pro 7</td>
            <td>Computers</td>
            <td>Microsoft</td>
            <td>$899</td>
            <td>40</td>
            <td>100</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Samsung QLED TV</td>
            <td>Televisions</td>
            <td>Samsung</td>
            <td>$1,299</td>
            <td>25</td>
            <td>70</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">LG OLED TV</td>
            <td>Televisions</td>
            <td>LG</td>
            <td>$1,499</td>
            <td>20</td>
            <td>50</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Canon EOS R5</td>
            <td>Cameras</td>
            <td>Canon</td>
            <td>$3,899</td>
            <td>10</td>
            <td>30</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Nikon Z7 II</td>
            <td>Cameras</td>
            <td>Nikon</td>
            <td>$3,299</td>
            <td>8</td>
            <td>25</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Apple Watch Series 7</td>
            <td>Wearables</td>
            <td>Apple</td>
            <td>$399</td>
            <td>150</td>
            <td>500</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Fitbit Charge 5</td>
            <td>Wearables</td>
            <td>Fitbit</td>
            <td>$179</td>
            <td>100</td>
            <td>250</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Dyson V11 Vacuum</td>
            <td>Home Appliances</td>
            <td>Dyson</td>
            <td>$599</td>
            <td>30</td>
            <td>90</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">iRobot Roomba i7+</td>
            <td>Home Appliances</td>
            <td>iRobot</td>
            <td>$799</td>
            <td>20</td>
            <td>70</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Bose SoundLink Revolve</td>
            <td>Speakers</td>
            <td>Bose</td>
            <td>$199</td>
            <td>80</td>
            <td>200</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Sonos One</td>
            <td>Speakers</td>
            <td>Sonos</td>
            <td>$219</td>
            <td>60</td>
            <td>180</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Apple iPad Pro</td>
            <td>Tablets</td>
            <td>Apple</td>
            <td>$1,099</td>
            <td>50</td>
            <td>150</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Samsung Galaxy Tab S7</td>
            <td>Tablets</td>
            <td>Samsung</td>
            <td>$649</td>
            <td>70</td>
            <td>130</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Amazon Echo Dot</td>
            <td>Smart Home</td>
            <td>Amazon</td>
            <td>$49</td>
            <td>300</td>
            <td>800</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Google Nest Hub</td>
            <td>Smart Home</td>
            <td>Google</td>
            <td>$89</td>
            <td>150</td>
            <td>400</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">PlayStation 5</td>
            <td>Gaming Consoles</td>
            <td>Sony</td>
            <td>$499</td>
            <td>10</td>
            <td>500</td>
            <td>Out of Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Xbox Series X</td>
            <td>Gaming Consoles</td>
            <td>Microsoft</td>
            <td>$499</td>
            <td>15</td>
            <td>450</td>
            <td>Out of Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Nintendo Switch</td>
            <td>Gaming Consoles</td>
            <td>Nintendo</td>
            <td>$299</td>
            <td>40</td>
            <td>600</td>
            <td>In Stock</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Apple MacBook Pro</td>
            <td>Computers</td>
            <td>Apple</td>
            <td>$1,299</td>
            <td>20</td>
            <td>100</td>
            <td>In Stock</td>
        </tr>
    </tbody>
</table>
```

## Sorting data

By setting the value `sortable` to `true` you'll enable all data rows from the datatable to be sortable by clicking on the table column heading. You can also disable it by setting the same option to `false`.

```html
<table id="sorting-table">
    <thead>
        <tr>
            <th>
                <span class="flex items-center">
                    Country
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    GDP
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Population
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    GDP per Capita
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">United States</td>
            <td>$21433 billion</td>
            <td>331 million</td>
            <td>$64763</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">China</td>
            <td>$14342 billion</td>
            <td>1441 million</td>
            <td>$9957</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Japan</td>
            <td>$5082 billion</td>
            <td>126 million</td>
            <td>$40335</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Germany</td>
            <td>$3846 billion</td>
            <td>83 million</td>
            <td>$46386</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">India</td>
            <td>$2875 billion</td>
            <td>1380 million</td>
            <td>$2083</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">United Kingdom</td>
            <td>$2829 billion</td>
            <td>67 million</td>
            <td>$42224</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">France</td>
            <td>$2716 billion</td>
            <td>65 million</td>
            <td>$41723</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Italy</td>
            <td>$2001 billion</td>
            <td>60 million</td>
            <td>$33350</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Canada</td>
            <td>$1643 billion</td>
            <td>38 million</td>
            <td>$43237</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">South Korea</td>
            <td>$1631 billion</td>
            <td>52 million</td>
            <td>$31365</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Russia</td>
            <td>$1460 billion</td>
            <td>144 million</td>
            <td>$10139</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Brazil</td>
            <td>$1430 billion</td>
            <td>213 million</td>
            <td>$6718</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Australia</td>
            <td>$1393 billion</td>
            <td>25 million</td>
            <td>$55720</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Spain</td>
            <td>$1326 billion</td>
            <td>47 million</td>
            <td>$28255</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Mexico</td>
            <td>$1194 billion</td>
            <td>129 million</td>
            <td>$9255</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Indonesia</td>
            <td>$1158 billion</td>
            <td>273 million</td>
            <td>$4241</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Netherlands</td>
            <td>$1010 billion</td>
            <td>17 million</td>
            <td>$59412</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Saudi Arabia</td>
            <td>$804 billion</td>
            <td>35 million</td>
            <td>$22914</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Turkey</td>
            <td>$761 billion</td>
            <td>84 million</td>
            <td>$9060</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Switzerland</td>
            <td>$741 billion</td>
            <td>9 million</td>
            <td>$82333</td>
        </tr>
    </tbody>
</table>
```

## Table pagination

Pagination is enabled by default for all datatables from Flowbite, however, you can disable it by setting the option `paging` to `false`. Use the `perPage` option to specify how many data rows to show by default. 

You can also set the `perPageSelect` option to set the selection options of the table.

```html
<table id="pagination-table">
    <thead>
        <tr>
            <th>
                <span class="flex items-center">
                    Model Name
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Developer
                </span>
            </th>
            <th data-type="date" data-format="Month YYYY">
                <span class="flex items-center">
                    Release Date
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Parameters
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Primary Application
                </span>
            </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">GPT-4</td>
            <td>OpenAI</td>
            <td>March 2023</td>
            <td>1 trillion</td>
            <td>Natural Language Processing</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">BERT</td>
            <td>Google</td>
            <td>October 2018</td>
            <td>340 million</td>
            <td>Natural Language Understanding</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">DALL-E 2</td>
            <td>OpenAI</td>
            <td>April 2022</td>
            <td>3.5 billion</td>
            <td>Image Generation</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">T5</td>
            <td>Google</td>
            <td>October 2019</td>
            <td>11 billion</td>
            <td>Text-to-Text Transfer</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">GPT-3.5</td>
            <td>OpenAI</td>
            <td>November 2022</td>
            <td>175 billion</td>
            <td>Natural Language Processing</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Codex</td>
            <td>OpenAI</td>
            <td>August 2021</td>
            <td>12 billion</td>
            <td>Code Generation</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">PaLM 2</td>
            <td>Google</td>
            <td>May 2023</td>
            <td>540 billion</td>
            <td>Multilingual Understanding</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">LaMDA</td>
            <td>Google</td>
            <td>May 2021</td>
            <td>137 billion</td>
            <td>Conversational AI</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">CLIP</td>
            <td>OpenAI</td>
            <td>January 2021</td>
            <td>400 million</td>
            <td>Image and Text Understanding</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">XLNet</td>
            <td>Google</td>
            <td>June 2019</td>
            <td>340 million</td>
            <td>Natural Language Processing</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Meena</td>
            <td>Google</td>
            <td>January 2020</td>
            <td>2.6 billion</td>
            <td>Conversational AI</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">BigGAN</td>
            <td>Google</td>
            <td>September 2018</td>
            <td>Unlimited</td>
            <td>Image Generation</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Electra</td>
            <td>Google</td>
            <td>March 2020</td>
            <td>14 million</td>
            <td>Natural Language Understanding</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Swin Transformer</td>
            <td>Microsoft</td>
            <td>April 2021</td>
            <td>88 million</td>
            <td>Vision Processing</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">GPT-NeoX-20B</td>
            <td>EleutherAI</td>
            <td>April 2022</td>
            <td>20 billion</td>
            <td>Natural Language Processing</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Ernie 3.0</td>
            <td>Baidu</td>
            <td>July 2021</td>
            <td>10 billion</td>
            <td>Natural Language Processing</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Turing-NLG</td>
            <td>Microsoft</td>
            <td>February 2020</td>
            <td>17 billion</td>
            <td>Natural Language Processing</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Wu Dao 2.0</td>
            <td>Beijing Academy of AI</td>
            <td>June 2021</td>
            <td>1.75 trillion</td>
            <td>Multimodal Processing</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Jukebox</td>
            <td>OpenAI</td>
            <td>April 2020</td>
            <td>1.2 billion</td>
            <td>Music Generation</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">StyleGAN2</td>
            <td>NVIDIA</td>
            <td>February 2020</td>
            <td>Unlimited</td>
            <td>Image Generation</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">FLAN</td>
            <td>Google</td>
            <td>December 2021</td>
            <td>137 billion</td>
            <td>Few-shot Learning</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">GShard</td>
            <td>Google</td>
            <td>June 2020</td>
            <td>600 billion</td>
            <td>Multilingual Understanding</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">AlphaFold</td>
            <td>DeepMind</td>
            <td>December 2020</td>
            <td>Unknown</td>
            <td>Protein Folding</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">GPT-J</td>
            <td>EleutherAI</td>
            <td>June 2021</td>
            <td>6 billion</td>
            <td>Natural Language Processing</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">M6</td>
            <td>Alibaba</td>
            <td>December 2020</td>
            <td>10 billion</td>
            <td>Multimodal Processing</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">Megatron-Turing NLG</td>
            <td>NVIDIA & Microsoft</td>
            <td>October 2021</td>
            <td>530 billion</td>
            <td>Natural Language Processing</td>
        </tr>
        <tr>
            <td class="font-medium text-heading whitespace-nowrap">DeepSpeed</td>
            <td>Microsoft</td>
            <td>February 2020</td>
            <td>Not disclosed</td>
            <td>AI Training Optimization</td>
        </tr>
    </tbody>
</table>
```

## Selecting rows

Use this example to enable the selection of rows by clicking anywhere one of the table row elements by copying setting the `multiselect` option to `true` and copying the JavaScript configuration from Flowbite.

Use the `datatable.selectrow` event to write your own code and get the data from the selected table row.

```html
<table id="selection-table">
    <thead>
        <tr>
            <th>
                <span class="flex items-center">
                    Name
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th data-type="date" data-format="YYYY/DD/MM">
                <span class="flex items-center">
                    Release Date
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    NPM Downloads
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Growth
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
        </tr>
    </thead>
    <tbody>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Flowbite</td>
            <td>2021/25/09</td>
            <td>269000</td>
            <td>49%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">React</td>
            <td>2013/24/05</td>
            <td>4500000</td>
            <td>24%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Angular</td>
            <td>2010/20/09</td>
            <td>2800000</td>
            <td>17%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Vue</td>
            <td>2014/12/02</td>
            <td>3600000</td>
            <td>30%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Svelte</td>
            <td>2016/26/11</td>
            <td>1200000</td>
            <td>57%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Ember</td>
            <td>2011/08/12</td>
            <td>500000</td>
            <td>44%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Backbone</td>
            <td>2010/13/10</td>
            <td>300000</td>
            <td>9%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">jQuery</td>
            <td>2006/28/01</td>
            <td>6000000</td>
            <td>5%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Bootstrap</td>
            <td>2011/19/08</td>
            <td>1800000</td>
            <td>12%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Foundation</td>
            <td>2011/23/09</td>
            <td>700000</td>
            <td>8%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Bulma</td>
            <td>2016/24/10</td>
            <td>500000</td>
            <td>7%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Next.js</td>
            <td>2016/25/10</td>
            <td>2300000</td>
            <td>45%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Nuxt.js</td>
            <td>2016/16/10</td>
            <td>900000</td>
            <td>50%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Meteor</td>
            <td>2012/17/01</td>
            <td>1000000</td>
            <td>10%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Aurelia</td>
            <td>2015/08/07</td>
            <td>200000</td>
            <td>20%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Inferno</td>
            <td>2016/27/09</td>
            <td>100000</td>
            <td>35%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Preact</td>
            <td>2015/16/08</td>
            <td>600000</td>
            <td>28%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Lit</td>
            <td>2018/28/05</td>
            <td>400000</td>
            <td>60%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Alpine.js</td>
            <td>2019/02/11</td>
            <td>300000</td>
            <td>70%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Stimulus</td>
            <td>2018/06/03</td>
            <td>150000</td>
            <td>25%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Solid</td>
            <td>2021/05/07</td>
            <td>250000</td>
            <td>80%</td>
        </tr>
    </tbody>
</table>
```

## Export files

If you want to enable the export of the table data, you can use the `simpleDatatables.exportCSV` function to export the data as a CSV file. The option is also available for TXT, JSON, and SQL formats.

```html
<table id="export-table">
    <thead>
        <tr>
            <th>
                <span class="flex items-center">
                    Name
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th data-type="date" data-format="YYYY/DD/MM">
                <span class="flex items-center">
                    Release Date
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    NPM Downloads
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
            <th>
                <span class="flex items-center">
                    Growth
                    <svg class="w-4 h-4 ms-1" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m8 15 4 4 4-4m0-6-4-4-4 4"/>
                    </svg>
                </span>
            </th>
        </tr>
    </thead>
    <tbody>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Flowbite</td>
            <td>2021/25/09</td>
            <td>269000</td>
            <td>49%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">React</td>
            <td>2013/24/05</td>
            <td>4500000</td>
            <td>24%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Angular</td>
            <td>2010/20/09</td>
            <td>2800000</td>
            <td>17%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Vue</td>
            <td>2014/12/02</td>
            <td>3600000</td>
            <td>30%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Svelte</td>
            <td>2016/26/11</td>
            <td>1200000</td>
            <td>57%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Ember</td>
            <td>2011/08/12</td>
            <td>500000</td>
            <td>44%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Backbone</td>
            <td>2010/13/10</td>
            <td>300000</td>
            <td>9%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">jQuery</td>
            <td>2006/28/01</td>
            <td>6000000</td>
            <td>5%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Bootstrap</td>
            <td>2011/19/08</td>
            <td>1800000</td>
            <td>12%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Foundation</td>
            <td>2011/23/09</td>
            <td>700000</td>
            <td>8%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Bulma</td>
            <td>2016/24/10</td>
            <td>500000</td>
            <td>7%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Next.js</td>
            <td>2016/25/10</td>
            <td>2300000</td>
            <td>45%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Nuxt.js</td>
            <td>2016/16/10</td>
            <td>900000</td>
            <td>50%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Meteor</td>
            <td>2012/17/01</td>
            <td>1000000</td>
            <td>10%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Aurelia</td>
            <td>2015/08/07</td>
            <td>200000</td>
            <td>20%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Inferno</td>
            <td>2016/27/09</td>
            <td>100000</td>
            <td>35%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Preact</td>
            <td>2015/16/08</td>
            <td>600000</td>
            <td>28%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Lit</td>
            <td>2018/28/05</td>
            <td>400000</td>
            <td>60%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Alpine.js</td>
            <td>2019/02/11</td>
            <td>300000</td>
            <td>70%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Stimulus</td>
            <td>2018/06/03</td>
            <td>150000</td>
            <td>25%</td>
        </tr>
        <tr class="hover:bg-neutral-secondary-soft cursor-pointer">
            <td class="font-medium text-heading whitespace-nowrap">Solid</td>
            <td>2021/05/07</td>
            <td>250000</td>
            <td>80%</td>
        </tr>
    </tbody>
</table>
```

## JavaScript behaviour

Learn more about how you can customize the DataTables plugin such as changing the default options, customizing the table appearance, dynamically loading data, and more by checking the examples below.

After installing the DataTables plugin either via NPM or CDN you can initialize by calling the `DataTable` constructor and passing the table selector as the first argument.

```javascript
// if you installed via CDN
const dataTable = new simpleDatatables.DataTable("#default-table");

// if you installed via NPM
import { DataTable } from "simple-datatables";
const dataTable = DataTable("#default-table");
```

You can pass an object of options as the second argument to customize the table appearance and behavior.

```javascript
const dataTable = new simpleDatatables.DataTable("#default-table", options);
```

After initializing the DataTable, you can access the instance methods and properties.

Here's a full list of the <a href="https://fiduswriter.github.io/simple-datatables/documentation/#events" target="_blank" rel="nofollow">exposed methods and properties</a> from the simple-datatables repository.

## Options

Check out some of the more commonly used options that you can pass to the DataTable instance.

### Injecting data

Use the `data` option to pass data from an array of arrays to the table using JavaScript.

```javascript
const customData = {
    "headings": [
        "Name",
        "Company",
        "Date",
    ],
    "data": [
        [
            "Flowbite",
            "Bergside",
            "05/23/2023",
        ],
        [
            "Next.js",
            "Vercel",
            "03/12/2024",
    ],
};

const dataTable = new DataTable("#default-table", { data: customData });
```

This is a useful feature where instead of a hard coded array you can pass data from an API or a JSON file.

### Appearance

Use the following options to customize the appearance of the table such as adding a caption, custom classes, footer, header, updating the HTML rendering template, and enabling vertical scrolling, and more.

```javascript
const dataTable = new DataTable("#default-table", {
    caption: "Flowbite is an open-source library",
    classes: {
        // add custom HTML classes, full list: https://fiduswriter.github.io/simple-datatables/documentation/classes
        // we recommend keeping the default ones in addition to whatever you want to add because Flowbite hooks to the default classes for styles
    },
    footer: true, // enable or disable the footer
    header: true, // enable or disable the header
    labels: {
        // add custom text for the labels, full list: https://fiduswriter.github.io/simple-datatables/documentation/labels
    },
    template: (options, dom) => {
        // add custom HTML template for the table, full list: https://fiduswriter.github.io/simple-datatables/documentation/template
    },
    scrollY: "300px", // enable vertical scrolling
});
```

These options are useful if you want to add your own HTML elements inside the dynamically generated table header or footer as we used in the export a file example above.

### Pagination

Use these options to enable pagination, set the number of rows per page, and customize the appearance.

```javascript
const dataTable = new DataTable("#default-table", {
    paging: true, // enable or disable pagination
    perPage: 10, // set the number of rows per page
    perPageSelect: [5, 10, 20, 50], // set the number of rows per page options
    firstLast: true, // enable or disable the first and last buttons
    nextPrev: true, // enable or disable the next and previous buttons
});
```

Pagination is a useful feature when you have a large dataset and you want to split it into multiple pages.

### Searching

These options can be used to enable searching, set the search placeholder, and customize the appearance.

```javascript
const dataTable = new DataTable("#default-table", {
    searchable: true, // enable or disable searching
    sensitivity: "base" // set the search sensitivity (base, accent, case, variant)
    searchQuerySeparator: " ", // set the search query separator
});
```

The searching feature is great when you have a large dataset and you want to search for a specific row.

### Sorting

Use these options to enable sorting, set the default sort column, and customize the sort appearance.

```javascript
const dataTable = new DataTable("#default-table", {
    sortable: true, // enable or disable sorting
    locale: "en-US", // set the locale for sorting
    numeric: true, // enable or disable numeric sorting
    caseFirst: "false", // set the case first for sorting (upper, lower)
    ignorePunctuation: true // enable or disable punctuation sorting
});
```

The sorting feature is useful when you want to sort the table rows based on a specific column.

## Methods

Check out some of the common methods that you can use to interact with the DataTable instance.

```javascript
// programatically search the table where the "term" variable is the query string
dataTable.search(term, columns);

// add a new table row data to the table (considering you have four columns)
dataTable.insert({
    "Heading 1": "Cell 1",
    "Heading 2": "Cell 2",
    "Heading 3": "Cell 3",
    "Heading 4": "Cell 4",
});

// updates the DOM of the table
dataTable.update();
```

Here's a full list of the <a href="https://fiduswriter.github.io/simple-datatables/documentation/#methods" target="_blank" rel="nofollow">exposed methods and properties</a> from the simple-datatables repository.

## License

All of the examples above built by Flowbite are open-source and licensed under the MIT license. The simple-datatables repository is also open-source and licensed under the <a href="https://github.com/fiduswriter/simple-datatables/blob/main/LICENSE" target="_blank" rel="nofollow">GNU license</a>.
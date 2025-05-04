let categories = {};
let vehicles = {};
let currentCategory = null;
let currentBrand = null;
let sortOrder = "asc";
let currentSort = "name";
let testDriveVeh = null;
let inTestDrive = false;
let brandLogos = {};
let vehiclesCache = {};
let vehicleListCache = null;
let previousSearchTerm = "";
let previousSortSettings = {};
let observer = null;
let loadedVehicleIds = new Set();

function updateDropdownState(type, value, text) {
    dropdownStates[type] = { value, text };
    const wrapper = document.getElementById(`${type}SelectWrapper`);
    if (!wrapper) return;

    // Update selected option
    const options = wrapper.querySelectorAll('.option');
    options.forEach(opt => {
        opt.classList.remove('selected');
        opt.setAttribute('aria-selected', 'false');
        if (opt.dataset.value === value) {
            opt.classList.add('selected');
            opt.setAttribute('aria-selected', 'true');
        }
    });

    // Update button text
    const button = wrapper.querySelector('.selected-option');
    if (button) {
        const span = button.querySelector('span');
        if (span) span.textContent = text;
        button.setAttribute('aria-expanded', 'false');
    }
    wrapper.classList.remove('open');
}

function showTestDriveTimer(show) {
  const timer = document.querySelector(".test-drive-timer");
  timer.style.display = show ? "flex" : "none";
  if (show) {
    timer.classList.add("active");
    const timerElement = document.querySelector(".timer-seconds");
    timerElement.style.color = "var(--text)";
  } else {
    timer.classList.remove("active");
  }
}

function updateTimerDisplay(seconds) {
  const timerElement = document.querySelector(".timer-seconds");
  timerElement.textContent = seconds.toString().padStart(2, "0");
  if (seconds <= 10) {
    timerElement.style.color = "#ef4444";
  } else {
    timerElement.style.color = "var(--text)";
  }
}

function sortVehicles(vehicleList, field = "name", order = "asc") {
  const cacheKey = `${field}-${order}-${vehicleList.length}`;

  if (
    previousSortSettings.cacheKey === cacheKey &&
    previousSortSettings.result
  ) {
    return previousSortSettings.result;
  }

  const sortedList = [...vehicleList].sort((a, b) => {
    let comparison = 0;
    switch (field) {
      case "price":
        comparison = a.price - b.price;
        break;
      case "name":
        comparison = a.name.localeCompare(b.name);
        break;
      case "brand":
        comparison = a.brand.localeCompare(b.brand);
        break;
    }
    return order === "asc" ? comparison : -comparison;
  });

  previousSortSettings = {
    cacheKey: cacheKey,
    result: sortedList,
  };

  return sortedList;
}

function filterVehicles(searchTerm) {
  if (searchTerm === previousSearchTerm && vehicleListCache) {
    return vehicleListCache;
  }

  let filteredVehicles;
  const cacheKey = `${currentCategory}-${currentBrand || "all"}`;

  if (vehiclesCache[cacheKey]) {
    filteredVehicles = vehiclesCache[cacheKey];
  } else {
    filteredVehicles =
      currentCategory === "all"
        ? Object.values(vehicles).flatMap((category) => Object.values(category))
        : Object.values(vehicles[currentCategory] || {});

    if (currentBrand) {
      filteredVehicles = filteredVehicles.filter(
        (vehicle) => vehicle.brand === currentBrand,
      );
    }

    vehiclesCache[cacheKey] = filteredVehicles;
  }

  if (!searchTerm) {
    previousSearchTerm = "";
    vehicleListCache = filteredVehicles;
    return filteredVehicles;
  }

  const results = filteredVehicles.filter(
    (vehicle) =>
      vehicle.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      vehicle.brand.toLowerCase().includes(searchTerm.toLowerCase()) ||
      vehicle.category.toLowerCase().includes(searchTerm.toLowerCase()),
  );

  previousSearchTerm = searchTerm;
  vehicleListCache = results;

  return results;
}

function setupBrandFilters() {
    const brands = new Set();
    Object.values(vehicles).forEach((category) => {
        Object.values(category).forEach((vehicle) => {
            if (vehicle.brand && vehicle.brand.trim()) {
                brands.add(vehicle.brand.trim());
            }
        });
    });

    const wrapper = document.getElementById("brandSelectWrapper");
    const selectedOption = wrapper.querySelector(".selected-option");
    const optionsContainer = wrapper.querySelector(".options-container");
    optionsContainer.innerHTML = "";

    // Create and append the "All Brands" option
    const allBrandsOption = document.createElement("div");
    allBrandsOption.className = "option";
    allBrandsOption.dataset.value = "";
    allBrandsOption.textContent = "All Brands";
    allBrandsOption.setAttribute('role', 'option');
    allBrandsOption.setAttribute('aria-selected', 'true');
    optionsContainer.appendChild(allBrandsOption);

    // Add brand options
    Array.from(brands)
        .sort((a, b) => a.localeCompare(b))
        .forEach((brand) => {
            const option = document.createElement("div");
            option.className = "option";
            option.dataset.value = brand;
            option.textContent = brand;
            option.setAttribute('role', 'option');
            option.setAttribute('aria-selected', 'false');
            optionsContainer.appendChild(option);
        });

    // Select "All Brands" by default
    allBrandsOption.classList.add('selected');
    selectedOption.querySelector('span').textContent = "All Brands";

    // Handle option selection
    optionsContainer.addEventListener("click", (e) => {
        const option = e.target.closest(".option");
        if (!option) return;
        
        updateDropdownState('brand', option.dataset.value || '', option.textContent);
        filterByBrand(option.dataset.value || null);
    });
}

function filterByBrand(brand) {
  vehicleListCache = null;
  previousSearchTerm = "";

  currentBrand = brand;

  const counterText = document.querySelector(".vehicle-counter");
  if (brand) {
    counterText.innerHTML =
      '<span id="vehicleCount">0</span> vehicles from <strong>' +
      brand +
      "</strong>";
    if (currentCategory !== "all") {
      counterText.innerHTML =
        '<span id="vehicleCount">0</span> ' +
        brand +
        " vehicles in <strong>" +
        categories[currentCategory] +
        "</strong>";
    }
  } else if (currentCategory !== "all") {
    counterText.innerHTML =
      '<span id="vehicleCount">0</span> vehicles in <strong>' +
      categories[currentCategory] +
      "</strong>";
  } else {
    counterText.innerHTML =
      '<span id="vehicleCount">0</span> vehicles available';
  }

  const searchTerm = document.getElementById("searchInput").value.trim();
  const filteredVehicles = filterVehicles(searchTerm);
  displayVehicles(sortVehicles(filteredVehicles, currentSort, sortOrder));
}

function setupSearch() {
  const searchInput = document.getElementById("searchInput");
  let debounceTimeout;

  searchInput.addEventListener("input", (e) => {
    clearTimeout(debounceTimeout);
    debounceTimeout = setTimeout(() => {
      const searchTerm = e.target.value.trim();

      const counterText = document.querySelector(".vehicle-counter");
      if (searchTerm) {
        counterText.innerHTML =
          '<span id="vehicleCount">0</span> results for <strong>"' +
          searchTerm +
          '"</strong>';
      } else {
        if (currentBrand) {
          counterText.innerHTML =
            '<span id="vehicleCount">0</span> vehicles from <strong>' +
            currentBrand +
            "</strong>";
          if (currentCategory !== "all") {
            counterText.innerHTML =
              '<span id="vehicleCount">0</span> ' +
              currentBrand +
              " vehicles in <strong>" +
              categories[currentCategory] +
              "</strong>";
          }
        } else if (currentCategory !== "all") {
          counterText.innerHTML =
            '<span id="vehicleCount">0</span> vehicles in <strong>' +
            categories[currentCategory] +
            "</strong>";
        } else {
          counterText.innerHTML =
            '<span id="vehicleCount">0</span> vehicles available';
        }
      }

      const filteredVehicles = filterVehicles(searchTerm);
      displayVehicles(sortVehicles(filteredVehicles, currentSort, sortOrder));
    }, 300);
  });
}

function setupCategories() {
  const categoriesDiv = document.querySelector(".categories");
  categoriesDiv.innerHTML = "";

  const fragment = document.createDocumentFragment();

  const allBtn = document.createElement("button");
  allBtn.className = "category-btn active";
  allBtn.textContent = "All Vehicles";
  allBtn.onclick = () => showCategory("all");
  fragment.appendChild(allBtn);

  Object.entries(categories).forEach(([key, name]) => {
    const btn = document.createElement("button");
    btn.className = "category-btn";
    btn.textContent = name;
    btn.onclick = () => showCategory(key);
    fragment.appendChild(btn);
  });

  categoriesDiv.appendChild(fragment);
}

function showCategory(categoryKey) {
  vehicleListCache = null;
  previousSearchTerm = "";
  vehiclesCache = {};
  previousSortSettings = {};

  currentCategory = categoryKey;

  const counterText = document.querySelector(".vehicle-counter");
  if (categoryKey === "all") {
    counterText.innerHTML =
      '<span id="vehicleCount">0</span> vehicles available';
  } else {
    counterText.innerHTML =
      '<span id="vehicleCount">0</span> vehicles in <strong>' +
      categories[categoryKey] +
      "</strong>";
  }

  document.querySelectorAll(".category-btn").forEach((btn) => {
    btn.classList.remove("active");
    if (
      (categoryKey === "all" && btn.textContent.trim() === "All Vehicles") ||
      (categories[categoryKey] &&
        btn.textContent.trim() === categories[categoryKey])
    ) {
      btn.classList.add("active");
    }
  });

  const vehicleList =
    categoryKey === "all"
      ? Object.values(vehicles).flatMap((category) => Object.values(category))
      : Object.values(vehicles[categoryKey] || {});

  displayVehicles(sortVehicles(vehicleList, currentSort, sortOrder));
}

function displayVehicles(vehicleList) {
  const countElement = document.getElementById("vehicleCount");
  countElement.textContent = vehicleList.length;

  const grid = document.querySelector(".vehicle-grid");
  grid.innerHTML = "";
  loadedVehicleIds.clear();

  if (observer) {
    observer.disconnect();
  }

  const fragment = document.createDocumentFragment();

  vehicleList.forEach((vehicle, index) => {
    const card = document.createElement("div");
    card.className = "vehicle-card";
    card.id = `vehicle-${index}`;
    card.dataset.vehicleIndex = index;

    card.innerHTML = `
            <div class="vehicle-placeholder" style="height: 160px; background: #f0f0f0;"></div>
            <div class="vehicle-info-container">
                <h3 class="vehicle-name">${vehicle.name}</h3>
                <p class="vehicle-price">$${vehicle.price.toLocaleString()}</p>
            </div>
        `;

    card.onclick = () => {
      loadVehicleData(card, vehicle);
      showVehicleInfo(
        vehicle,
        `https://docs.fivem.net/vehicles/${vehicle.model.toLowerCase()}.webp`,
      );
    };

    fragment.appendChild(card);
  });

  grid.appendChild(fragment);

  observer = new IntersectionObserver(
    (entries, observer) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          const card = entry.target;
          const index = parseInt(card.dataset.vehicleIndex);
          const vehicle = vehicleList[index];

          loadVehicleData(card, vehicle);

          observer.unobserve(card);
        }
      });
    },
    {
      root: null,
      rootMargin: "200px",
      threshold: 0.1,
    },
  );

  document.querySelectorAll(".vehicle-card").forEach((card) => {
    observer.observe(card);
  });
}

function loadVehicleData(card, vehicle) {
  const vehicleId = vehicle.model;

  if (loadedVehicleIds.has(vehicleId)) {
    return;
  }

  const imageUrl = `https://docs.fivem.net/vehicles/${vehicle.model.toLowerCase()}.webp`;

  const brandLogoUrl = `nui://${GetParentResourceName()}/html/assets/carbrands/${vehicle.brand.toLowerCase()}.webp`;

  card.innerHTML = `
        <div class="vehicle-image" style="background-image: url('${imageUrl}')"></div>
        <div class="vehicle-info-container">
            <h3 class="vehicle-name">${vehicle.name}</h3>
            <div class="vehicle-brand">
                <img src="${brandLogoUrl}" alt="${vehicle.brand}" width="20" height="20" loading="lazy">
                <span>${vehicle.brand}</span>
            </div>
            <p class="vehicle-price">$${vehicle.price.toLocaleString()}</p>
        </div>
    `;

  loadedVehicleIds.add(vehicleId);
}

function showVehicleInfo(vehicle, imageUrl) {
  const info = document.querySelector(".vehicle-info");
  info.classList.remove("hidden");

  const brandLogoUrl = `nui://${GetParentResourceName()}/html/assets/carbrands/${vehicle.brand.toLowerCase()}.webp`;

  info.innerHTML = `
        <button class="close-btn" onclick="closeVehicleInfo()">×</button>
        <div class="vehicle-image" style="background-image: url('${imageUrl}')"></div>
        <img class="brand-logo" src="${brandLogoUrl}" alt="${vehicle.brand}" loading="lazy">
        <h2 class="vehicle-name">${vehicle.name}</h2>
        <div class="vehicle-details">
            <div class="stat">
                <span>Brand</span>
                <span>${vehicle.brand}</span>
            </div>
            <div class="stat">
                <span>Price</span>
                <span>$${vehicle.price.toLocaleString()}</span>
            </div>
            <div class="stat">
                <span>Category</span>
                <span>${categories[vehicle.category]}</span>
            </div>
        </div>
        <div class="vehicle-actions">
            <button class="test-drive-btn" onclick="startTestDrive('${vehicle.model}')">Test Drive</button>
            <button class="buy-btn" onclick="buyVehicle('${vehicle.model}', ${vehicle.price})">Purchase</button>
            ${window.gangData ? 
                `<button class="buy-gang-btn" onclick="buyVehicleForGang('${vehicle.model}', ${vehicle.price})">Buy for Gang</button>` 
                : ''}
        </div>
    `;
}

// Pure data-driven dropdown management
const dropdowns = {
    data: {
        sort: {
            value: 'name-asc',
            text: 'Name (A-Z)'
        },
        brand: {
            value: '',
            text: 'All Brands'
        }
    },
    
    reset() {
        // Reset internal data
        this.data.sort = {
            value: 'name-asc',
            text: 'Name (A-Z)'
        };
        this.data.brand = {
            value: '',
            text: 'All Brands'
        };
        
        // Reset DOM state
        this.updateDOM();
        
        // Reset filter state
        currentSort = "name";
        sortOrder = "asc";
        currentBrand = null;
    },
    
    updateDOM() {
        // Update sort dropdown
        const sortSelect = document.querySelector('#sortSelectWrapper');
        if (sortSelect) {
            // Close dropdown
            sortSelect.classList.remove('open');
            const sortButton = sortSelect.querySelector('.selected-option');
            sortButton.setAttribute('aria-expanded', 'false');
            
            // Update selection
            sortSelect.querySelectorAll('.option').forEach(opt => {
                const isSelected = opt.dataset.value === this.data.sort.value;
                opt.classList.toggle('selected', isSelected);
                opt.setAttribute('aria-selected', isSelected);
            });
            
            // Update text
            sortButton.querySelector('span').textContent = this.data.sort.text;
        }
        
        // Update brand dropdown
        const brandSelect = document.querySelector('#brandSelectWrapper');
        if (brandSelect) {
            // Close dropdown
            brandSelect.classList.remove('open');
            const brandButton = brandSelect.querySelector('.selected-option');
            brandButton.setAttribute('aria-expanded', 'false');
            
            // Update selection
            brandSelect.querySelectorAll('.option').forEach(opt => {
                const isSelected = opt.dataset.value === this.data.brand.value;
                opt.classList.toggle('selected', isSelected);
                opt.setAttribute('aria-selected', isSelected);
            });
            
            // Update text
            brandButton.querySelector('span').textContent = this.data.brand.text;
        }
    },
    
    handleClick(e) {
        const select = e.target.closest('.custom-select');
        if (!select) {
            // Close all dropdowns when clicking outside
            document.querySelectorAll('.custom-select').forEach(s => {
                s.classList.remove('open');
                s.querySelector('.selected-option').setAttribute('aria-expanded', 'false');
            });
            return;
        }
        
        // Handle dropdown button clicks
        if (e.target.closest('.selected-option')) {
            e.stopPropagation();
            const button = e.target.closest('.selected-option');
            const wasOpen = select.classList.contains('open');
            
            // Close all dropdowns
            document.querySelectorAll('.custom-select').forEach(s => {
                s.classList.remove('open');
                s.querySelector('.selected-option').setAttribute('aria-expanded', 'false');
            });
            
            // Toggle current
            if (!wasOpen) {
                select.classList.add('open');
                button.setAttribute('aria-expanded', 'true');
            }
            return;
        }
        
        // Handle option selection
        const option = e.target.closest('.option');
        if (option) {
            e.stopPropagation();
            
            // Update data
            if (select.id === 'sortSelectWrapper') {
                this.data.sort = {
                    value: option.dataset.value,
                    text: option.textContent
                };
                const [field, order] = option.dataset.value.split('-');
                currentSort = field;
                sortOrder = order;
                previousSortSettings = {};
                
                const searchTerm = document.getElementById("searchInput").value.trim();
                const filteredVehicles = filterVehicles(searchTerm);
                displayVehicles(sortVehicles(filteredVehicles, currentSort, sortOrder));
            } else if (select.id === 'brandSelectWrapper') {
                this.data.brand = {
                    value: option.dataset.value,
                    text: option.textContent
                };
                filterByBrand(option.dataset.value || null);
            }
            
            // Update visual state
            this.updateDOM();
        }
    }
};

// Initialize dropdown handling
document.addEventListener('click', dropdowns.handleClick.bind(dropdowns));

// Update functions to use data-driven dropdowns
function setupDropdowns() {
    dropdowns.reset();
}

function closeVehicleInfo() {
    document.querySelector(".vehicle-info").classList.add("hidden");
    dropdowns.reset();
}

function startTestDrive(model) {
    if (!inTestDrive) {
        showTestDriveTimer(true);
        inTestDrive = true;
        dropdowns.reset();
        fetch(`https://${GetParentResourceName()}/testDrive`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ model }),
        }).catch(() => {});
        document.getElementById("container").classList.add("hidden");
        closeVehicleInfo();
    }
}

function buyVehicle(model, price) {
    dropdowns.reset();
    fetch(`https://${GetParentResourceName()}/buyVehicle`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ model, price }),
    }).catch(() => {});
    document.getElementById("container").classList.add("hidden");
    closeVehicleInfo();
}

function buyVehicleForGang(model, price) {
    dropdowns.reset();
    fetch(`https://${GetParentResourceName()}/buyVehicle`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ model, price, forGang: true }),
    }).catch(() => {});
    document.getElementById("container").classList.add("hidden");
    closeVehicleInfo();
}

// Update window message handler
window.addEventListener("message", function (event) {
    switch (event.data.action) {
        case "open":
            // Set data first
            categories = event.data.categories;
            vehicles = event.data.vehicles;
            window.gangData = event.data.gang;

            // Reset states
            vehiclesCache = {};
            vehicleListCache = null;
            previousSearchTerm = "";
            previousSortSettings = {};
            document.querySelector('#searchInput').value = '';

            // Clean up observers
            if (observer) {
                observer.disconnect();
                observer = null;
            }
            loadedVehicleIds.clear();

            // Setup fresh
            setupCategories();
            setupBrandFilters();
            setupSearch();
            setupDropdowns();
            
            // Show content
            document.getElementById("container").classList.remove("hidden");
            showCategory("all");
            inTestDrive = false;
            showTestDriveTimer(false);
            break;
        case "updateTestDriveTime":
            showTestDriveTimer(true);
            updateTimerDisplay(event.data.time);
            break;
        case "testDriveEnded":
            inTestDrive = false;
            showTestDriveTimer(false);
            break;
        case "resetTestDrive":
            inTestDrive = false;
            showTestDriveTimer(false);
            break;
    }
});

function openDealerMenu(categories) {
  const container = document.getElementById("container");
  container.classList.remove("hidden");

  if (document.querySelector(".dealer-form")) {
    return;
  }

  const dealerForm = document.createElement("div");
  dealerForm.className = "dealer-form";

  const categoryOptions = Object.entries(categories)
    .map(([key, name]) => `<option value="${key}">${name}</option>`)
    .join("");

  dealerForm.innerHTML = `
        <h2>Add Vehicle to Stock</h2>
        <form id="addVehicleForm">
            <input type="text" id="vehicleName" placeholder="Vehicle Name" required>
            <input type="text" id="vehicleModel" placeholder="Spawn Code" required>
            <input type="number" id="vehiclePrice" placeholder="Price" required min="1">
            <input type="text" id="vehicleBrand" placeholder="Brand" required>
            <select id="vehicleCategory" required>
                <option value="">Select Category</option>
                ${categoryOptions}
            </select>
            <button type="submit">Add Vehicle</button>
        </form>
    `;

  container.appendChild(dealerForm);

  document
    .getElementById("addVehicleForm")
    .addEventListener("submit", function (e) {
      e.preventDefault();

      const vehicleData = {
        name: document.getElementById("vehicleName").value,
        model: document.getElementById("vehicleModel").value,
        price: parseInt(document.getElementById("vehiclePrice").value),
        brand: document.getElementById("vehicleBrand").value,
        category: document.getElementById("vehicleCategory").value,
      };

      fetch(`https://${GetParentResourceName()}/addVehicle`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(vehicleData),
      }).catch(() => {});

      e.target.reset();
    });
}

document.addEventListener("keydown", function (event) {
  if (event.key === "Escape") {
    document.getElementById("container").classList.add("hidden");
    fetch(`https://${GetParentResourceName()}/close`, {
      method: "POST",
    }).catch(() => {});
  }
});

window.addEventListener("beforeunload", function () {
  if (observer) {
    observer.disconnect();
    observer = null;
  }
});

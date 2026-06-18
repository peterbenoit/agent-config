---
name: angular
category: Frontend
tags: [angular, typescript, rxjs, signals, standalone, pinia, ng, cli]
updated: 2026-06-18
triggers: ["Angular","NgModule","OnPush","RxJS","angular component","ng generate","signals","standalone component","this is an Angular app"]
description: >
  Act as the Angular implementation advisor. Use when building or reviewing Angular components,
  services, routing, reactive forms, RxJS operators, or signals. Trigger on phrases like
  "Angular", "ng generate", "standalone component", "NgModule", "RxJS", "OnPush", "signals",
  "angular component", or "this is an Angular app".
---

# Angular Advisor

You are the Angular implementation advisor. Angular has strong conventions — work with them.
Deviation creates code that the framework cannot optimize and that other Angular developers
cannot read. Current baseline: Angular 17+ with standalone components.

**Docs:** https://angular.dev

---

## Components

Standalone components are the default in Angular 17+. No NgModule required for new code.

```ts
import { Component, input, output, ChangeDetectionStrategy } from '@angular/core';

@Component({
  selector: 'app-user-card',
  standalone: true,
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="card">
      <h2>{{ user().name }}</h2>
      <button type="button" (click)="select.emit(user())">Select</button>
    </div>
  `,
})
export class UserCardComponent {
  user   = input.required<User>();
  select = output<User>();
}
```

**Always use `OnPush`.** Default change detection re-renders every component on every event.
`OnPush` only re-renders when an input reference changes, an async-piped observable emits,
a signal it reads changes, or `markForCheck()` is called.

---

## Signals (Angular 16+)

Prefer signals over `BehaviorSubject` for local state and simple shared state:

```ts
import { signal, computed, effect } from '@angular/core';

const count    = signal(0);
const doubled  = computed(() => count() * 2);

count.set(1);
count.update(n => n + 1);

effect(() => { console.log('count:', count()); });
```

In templates, call signals as functions: `{{ count() }}`

---

## Services and DI

```ts
import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class UserService {
  private http = inject(HttpClient);
  private url  = '/api/users';

  getUsers(): Observable<User[]>      { return this.http.get<User[]>(this.url); }
  getUser(id: string): Observable<User> { return this.http.get<User>(`${this.url}/${id}`); }
}
```

Use `inject()` in new code. Constructor injection is equivalent but more verbose.
Use `\Drupal::service()` equivalents (global container access) only in procedural contexts.

---

## Routing

```ts
// app.routes.ts
export const routes: Routes = [
  { path: '', component: HomeComponent },
  {
    path: 'dashboard',
    canActivate: [authGuard],
    loadChildren: () => import('./dashboard/dashboard.routes').then(m => m.ROUTES),
  },
  { path: '**', redirectTo: '' },
];

// Functional guard (Angular 15+)
export const authGuard: CanActivateFn = () => {
  const auth   = inject(AuthService);
  const router = inject(Router);
  return auth.isAuthenticated() || router.createUrlTree(['/login']);
};
```

Lazy-load every feature route. Do not import feature components directly in `app.routes.ts`.

---

## Reactive Forms

```ts
@Component({ standalone: true, imports: [ReactiveFormsModule], template: `
  <form [formGroup]="form" (ngSubmit)="submit()">
    <input formControlName="email" type="email">
    @if (form.controls.email.invalid && form.controls.email.touched) {
      <span>Valid email required</span>
    }
    <button type="submit" [disabled]="form.invalid">Submit</button>
  </form>
`})
export class LoginComponent {
  private fb = inject(FormBuilder);

  form = this.fb.group({
    email:    ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(8)]],
  });

  submit() { if (this.form.valid) console.log(this.form.getRawValue()); }
}
```

---

## RxJS

```ts
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { switchMap, catchError, debounceTime, distinctUntilChanged } from 'rxjs/operators';
import { EMPTY } from 'rxjs';

// Prefer takeUntilDestroyed — no manual unsubscribe (Angular 16+)
this.service.data$.pipe(takeUntilDestroyed()).subscribe(d => { ... });

// Search / autocomplete — switchMap cancels previous request
searchControl.valueChanges.pipe(
  debounceTime(300),
  distinctUntilChanged(),
  switchMap(term => this.service.search(term).pipe(catchError(() => EMPTY))),
).subscribe(results => { ... });
```

| Operator | Use when |
|---|---|
| `switchMap` | Search, autocomplete — cancel previous on new emission |
| `mergeMap` | All concurrent requests should complete |
| `concatMap` | Order matters — queue emissions |
| `exhaustMap` | Login, submit — ignore new until current finishes |

---

## HTTP Interceptors

```ts
export const errorInterceptor: HttpInterceptorFn = (req, next) =>
  next(req).pipe(
    catchError(err => {
      if (err.status === 401) inject(Router).navigate(['/login']);
      return throwError(() => err);
    }),
  );

// app.config.ts
provideHttpClient(withInterceptors([errorInterceptor]))
```

---

## CLI Quick Reference

```bash
ng generate component features/user/user-list --standalone
ng generate service core/services/user
ng generate guard core/guards/auth --functional
ng generate pipe shared/pipes/truncate

ng build --configuration=production
ng test --watch=false --code-coverage
```

---

## Common Mistakes

| Mistake | Fix |
|---|---|
| Default change detection on leaf components | Add `OnPush` |
| `subscribe()` without cleanup | Use `async` pipe or `takeUntilDestroyed()` |
| `*ngFor` without `trackBy` | Track by stable id — use `track item.id` in Angular 17+ `@for` |
| Feature components imported in app routes | Lazy-load with `loadChildren` |
| Logic in templates | Move to component methods or computed signals |

---

## Project Context

Check AGENTS.md or local skill overlays for:
- Angular version and whether the project uses NgModule or standalone conventions
- State management approach (signals, NgRx, Akita, or service-based)
- UI component library in use (Angular Material, PrimeNG, custom)
- API base URL and whether an HTTP interceptor is already configured
